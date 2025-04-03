defmodule Honey.Mix.Tasks.CompileBPF do
  @shortdoc "Compile eBPF programs using Clang, LLC and bpftool"
  use Mix.Task
  require Logger

  @target "prog"
  @src_dir File.cwd!()
  @priv_dir Path.join([@src_dir, "..", "..", "priv"])
  @c_boilerplates Path.join(@priv_dir, "c_boilerplates")
  @obj_folder Path.join(@src_dir, "obj")
  @libs "-lbpf -lelf -lz"

  def run(args) do
    {target, _} = OptionParser.parse!(args, switches: [target: :string])
    target = if target == [], do: @target, else: hd(target)

    clean()
    compile(target)
    compress(target)
  end

  defp clean do
    File.rm_rf!(Path.join(@src_dir, "bin"))
    File.rm_rf!(Path.join(@src_dir, "obj"))
  end

  defp compile(target) do
    Logger.info("🔨 Starting compilation for target: #{target}")
    File.mkdir_p!(Path.join(@src_dir, "obj"))
    File.mkdir_p!(Path.join(@src_dir, "bin"))

    with {:ok, _} <- execute_step("BPF object compilation", &compile_bpf_object/1, target),
         {:ok, _} <- execute_step("Skeleton generation", &generate_skeleton/1, target),
         {:ok, _} <- execute_step("Binary compilation", &compile_binary/1, target) do
      Logger.info("✅ All compilation steps completed successfully")
      :ok
    else
      {:error, step, error} ->
        Logger.error("❌ Compilation failed during: #{step}")
        Logger.error("Error details: #{inspect(error)}")
        {:error, error}
    end
  end

  defp execute_step(step_name, step_function, target) do
    Logger.info("🚀 Starting: #{step_name}")

    case step_function.(target) do
      :ok ->
        Logger.info("✔️  Completed: #{step_name}")
        {:ok, step_name}

      {:error, error} ->
        {:error, step_name, error}
    end
  end

  # Funções modificadas para retornar :ok/{:error}
  defp compile_bpf_object(target) do
    src = Path.join([@src_dir, "src", "#{target}.bpf.c"])
    ll_output = Path.join(@obj_folder, "#{target}.bpf.ll")

    case System.cmd("clang", [
           "-S",
           "-target",
           "bpf",
           "-D__BPF_TRACING__",
           "-I#{@obj_folder}",
           "-I#{@c_boilerplates}",
           "-O2",
           "-emit-llvm",
           "-c",
           "-g",
           src,
           "-o",
           ll_output
         ]) do
      {_, 0} ->
        System.cmd("llc", [
          "-march=bpf",
          "-filetype=obj",
          "-o",
          "#{@obj_folder}/#{target}.bpf.o",
          ll_output
        ])

        :ok

      {error, _} ->
        {:error, "Clang failed: #{error}"}
    end
  end

  defp generate_skeleton(target) do
    input = "#{@obj_folder}/#{target}.bpf.o"
    output = "#{@obj_folder}/#{target}.skel.h"

    case System.cmd("bpftool", ["gen", "skeleton", input]) do
      {result, 0} ->
        File.write!(output, result)
        :ok

      {error, _} ->
        {:error, "Bpftool failed: #{error}"}
    end
  end

  defp compile_binary(target) do
    src = Path.join([@src_dir, "src", "#{target}.c"])
    output = Path.join(@src_dir, "bin/#{target}")

    case System.cmd("gcc", [
           "-I#{@obj_folder}",
           "-I#{@c_boilerplates}",
           "-o",
           output,
           src,
           "-Wl,-rpath=#{@priv_dir}/libbpf",
           @libs
         ]) do
      {_, 0} -> :ok
      {error, _} -> {:error, "GCC failed: #{error}"}
    end
  end

  defp compress(target) do
    compress_dir = Path.join(@src_dir, "compress")
    File.mkdir_p!(compress_dir)

    src = Path.join([@src_dir, "src", "#{target}.bpf.c"])
    temp1 = Path.join(compress_dir, "bpf.nocomm.temp.c")
    temp2 = Path.join(compress_dir, "bpf.nospace.temp.c")

    System.cmd("gcc", ["-fpreprocessed", "-dD", "-E", "-P", src, "-o", temp1])
    System.cmd("sed", ["-e", "s/\\s\\s\\s*/ /g", temp1], into: File.stream!(temp2))
    System.cmd("gzip", ["-c", temp2], into: File.stream!(Path.join(compress_dir, "bpf.gz")))

    File.rm!([temp1, temp2])
  end
end
