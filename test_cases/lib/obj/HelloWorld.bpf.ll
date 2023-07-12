; ModuleID = '/home/vinicius/honey-potion/test_cases/lib/src/HelloWorld.bpf.c'
source_filename = "/home/vinicius/honey-potion/test_cases/lib/src/HelloWorld.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr, ptr }
%struct.anon.1 = type { ptr, ptr, ptr, ptr }
%struct.anon.2 = type { ptr, ptr, ptr, ptr }
%struct.anon.3 = type { ptr, ptr, ptr, ptr }
%struct.anon.4 = type { ptr, ptr, ptr, ptr }
%struct.OpResult = type { %struct.Generic, i32, [150 x i8] }
%struct.Generic = type { i32, %union.ElixirValue }
%union.ElixirValue = type { i64, [8 x i8] }

@LICENSE = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !0
@string_pool_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !50
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !20
@string_pool_index_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !72
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !27
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1, !dbg !29
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1, !dbg !34
@heap_map = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !100
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !44
@heap_index_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !112
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !46
@tuple_pool_map = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !80
@tuple_pool_index_map = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !92
@__const.main_func.____fmt = private unnamed_addr constant [13 x i8] c"Hello world!\00", align 1
@__const.main_func.____fmt.8 = private unnamed_addr constant [7 x i8] c"** %s\0A\00", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @LICENSE, ptr @heap_index_map, ptr @heap_map, ptr @main_func, ptr @string_pool_index_map, ptr @string_pool_map, ptr @tuple_pool_index_map, ptr @tuple_pool_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(ptr nocapture readnone %0) #0 section "tracepoint/syscalls/sys_enter_write" !dbg !147 {
  call void @llvm.dbg.declare(metadata ptr undef, metadata !169, metadata !DIExpression()), !dbg !245
  call void @llvm.dbg.declare(metadata ptr undef, metadata !177, metadata !DIExpression()), !dbg !246
  call void @llvm.dbg.declare(metadata ptr undef, metadata !178, metadata !DIExpression()), !dbg !247
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  %4 = alloca [13 x i8], align 1
  %5 = alloca [7 x i8], align 1
  call void @llvm.dbg.value(metadata ptr poison, metadata !168, metadata !DIExpression()), !dbg !248
  call void @llvm.lifetime.start.p0(i64 184, ptr nonnull %2) #6, !dbg !249
  call void @llvm.dbg.declare(metadata ptr %2, metadata !179, metadata !DIExpression()), !dbg !250
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(184) %2, i8 0, i64 184, i1 false), !dbg !250
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6, !dbg !251
  call void @llvm.dbg.value(metadata i32 0, metadata !219, metadata !DIExpression()), !dbg !248
  store i32 0, ptr %3, align 4, !dbg !252, !tbaa !253
  call void @llvm.dbg.value(metadata ptr %3, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !248
  %6 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %3) #6, !dbg !257
  call void @llvm.dbg.value(metadata ptr %6, metadata !220, metadata !DIExpression()), !dbg !248
  %7 = icmp eq ptr %6, null, !dbg !258
  br i1 %7, label %8, label %11, !dbg !260

8:                                                ; preds = %1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !261
  %9 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !263
  store i32 1, ptr %9, align 8, !dbg !263, !tbaa.struct !264
  %10 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !263
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %10, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !263, !tbaa.struct !266
  br label %45, !dbg !267

11:                                               ; preds = %1
  call void @llvm.dbg.value(metadata ptr %3, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !248
  %12 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_index_map, ptr noundef nonnull %3) #6, !dbg !268
  call void @llvm.dbg.value(metadata ptr %12, metadata !223, metadata !DIExpression()), !dbg !248
  %13 = icmp eq ptr %12, null, !dbg !269
  br i1 %13, label %14, label %17, !dbg !271

14:                                               ; preds = %11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !272
  %15 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !274
  store i32 1, ptr %15, align 8, !dbg !274, !tbaa.struct !264
  %16 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !274
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %16, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !274, !tbaa.struct !266
  br label %45, !dbg !275

17:                                               ; preds = %11
  store i32 0, ptr %12, align 4, !dbg !276, !tbaa !253
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %6, ptr noundef nonnull align 1 dereferenceable(3) @.str.2, i64 3, i1 false), !dbg !277
  %18 = getelementptr inbounds i8, ptr %6, i64 3, !dbg !278
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %18, ptr noundef nonnull align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !dbg !279
  %19 = getelementptr inbounds i8, ptr %6, i64 8, !dbg !280
  store i32 1702195828, ptr %19, align 1, !dbg !281
  call void @llvm.dbg.value(metadata ptr %3, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !248
  %20 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_map, ptr noundef nonnull %3) #6, !dbg !282
  call void @llvm.dbg.value(metadata ptr %20, metadata !225, metadata !DIExpression()), !dbg !248
  %21 = icmp eq ptr %20, null, !dbg !283
  br i1 %21, label %22, label %25, !dbg !285

22:                                               ; preds = %17
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !286
  %23 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !288
  store i32 1, ptr %23, align 8, !dbg !288, !tbaa.struct !264
  %24 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !288
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %24, ptr noundef nonnull align 4 dereferenceable(150) @.str.5, i64 150, i1 false), !dbg !288, !tbaa.struct !266
  br label %45, !dbg !289

25:                                               ; preds = %17
  call void @llvm.dbg.value(metadata ptr %3, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !248
  %26 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_index_map, ptr noundef nonnull %3) #6, !dbg !290
  call void @llvm.dbg.value(metadata ptr %26, metadata !230, metadata !DIExpression()), !dbg !248
  %27 = icmp eq ptr %26, null, !dbg !291
  br i1 %27, label %28, label %31, !dbg !293

28:                                               ; preds = %25
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !294
  %29 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !296
  store i32 1, ptr %29, align 8, !dbg !296, !tbaa.struct !264
  %30 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !296
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %30, ptr noundef nonnull align 4 dereferenceable(150) @.str.6, i64 150, i1 false), !dbg !296, !tbaa.struct !266
  br label %45, !dbg !297

31:                                               ; preds = %25
  store i32 0, ptr %26, align 4, !dbg !298, !tbaa !253
  call void @llvm.dbg.value(metadata ptr %3, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !248
  %32 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_map, ptr noundef nonnull %3) #6, !dbg !299
  call void @llvm.dbg.value(metadata ptr %32, metadata !231, metadata !DIExpression()), !dbg !248
  %33 = icmp eq ptr %32, null, !dbg !300
  br i1 %33, label %34, label %37, !dbg !302

34:                                               ; preds = %31
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !303
  %35 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !305
  store i32 1, ptr %35, align 8, !dbg !305, !tbaa.struct !264
  %36 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !305
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %36, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !305, !tbaa.struct !266
  br label %45, !dbg !306

37:                                               ; preds = %31
  call void @llvm.dbg.value(metadata ptr %3, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !248
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_index_map, ptr noundef nonnull %3) #6, !dbg !307
  call void @llvm.dbg.value(metadata ptr %38, metadata !234, metadata !DIExpression()), !dbg !248
  %39 = icmp eq ptr %38, null, !dbg !308
  br i1 %39, label %40, label %43, !dbg !310

40:                                               ; preds = %37
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !311
  %41 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !313
  store i32 1, ptr %41, align 8, !dbg !313, !tbaa.struct !264
  %42 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !313
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %42, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !313, !tbaa.struct !266
  br label %45, !dbg !314

43:                                               ; preds = %37
  store i32 0, ptr %38, align 4, !dbg !315, !tbaa !253
  call void @llvm.dbg.value(metadata i64 undef, metadata !235, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 64)), !dbg !248
  call void @llvm.dbg.value(metadata i64 8589934592, metadata !235, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !248
  call void @llvm.dbg.value(metadata i64 undef, metadata !235, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !248
  call void @llvm.lifetime.start.p0(i64 13, ptr nonnull %4) #6, !dbg !316
  call void @llvm.dbg.declare(metadata ptr %4, metadata !236, metadata !DIExpression()), !dbg !316
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(13) %4, ptr noundef nonnull align 1 dereferenceable(13) @__const.main_func.____fmt, i64 13, i1 false), !dbg !316
  %44 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %4, i32 noundef 13, i64 noundef 8589934592) #6, !dbg !316
  call void @llvm.lifetime.end.p0(i64 13, ptr nonnull %4) #6, !dbg !317
  call void @llvm.dbg.value(metadata i32 2, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !248
  call void @llvm.dbg.value(metadata i32 undef, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !248
  call void @llvm.dbg.value(metadata i64 0, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !248
  call void @llvm.dbg.value(metadata i64 undef, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !248
  br label %48, !dbg !318

45:                                               ; preds = %40, %34, %28, %22, %14, %8
  call void @llvm.dbg.label(metadata !244), !dbg !319
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %5) #6, !dbg !320
  call void @llvm.dbg.declare(metadata ptr %5, metadata !239, metadata !DIExpression()), !dbg !320
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %5, ptr noundef nonnull align 1 dereferenceable(7) @__const.main_func.____fmt.8, i64 7, i1 false), !dbg !320
  %46 = getelementptr inbounds %struct.OpResult, ptr %2, i64 0, i32 2, !dbg !320
  %47 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %5, i32 noundef 7, ptr noundef nonnull %46) #6, !dbg !320
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %5) #6, !dbg !321
  br label %48, !dbg !322

48:                                               ; preds = %45, %43
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6, !dbg !323
  call void @llvm.lifetime.end.p0(i64 184, ptr nonnull %2) #6, !dbg !323
  ret i32 0, !dbg !323
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nocallback nofree nounwind willreturn writeonly }
attributes #4 = { argmemonly mustprogress nocallback nofree nounwind willreturn }
attributes #5 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!142, !143, !144, !145}
!llvm.ident = !{!146}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !22, line: 27, type: !139, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/vinicius/honey-potion/test_cases/lib/src/HelloWorld.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "36f17d6f81e8de0d822e68a3b033ea2d")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Type", file: !6, line: 40, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_generic.bpf.h", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "699e26b6150612b5cee9098b6ccdafaf")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18}
!9 = !DIEnumerator(name: "INVALID_TYPE", value: 0)
!10 = !DIEnumerator(name: "PATTERN_M", value: 1)
!11 = !DIEnumerator(name: "INTEGER", value: 2)
!12 = !DIEnumerator(name: "DOUBLE", value: 3)
!13 = !DIEnumerator(name: "STRING", value: 4)
!14 = !DIEnumerator(name: "ATOM", value: 5)
!15 = !DIEnumerator(name: "TUPLE", value: 6)
!16 = !DIEnumerator(name: "LIST", value: 7)
!17 = !DIEnumerator(name: "STRUCT", value: 8)
!18 = !DIEnumerator(name: "TYPE_Syscalls_enter_kill_arg", value: 9)
!19 = !{!0, !20, !27, !29, !34, !39, !44, !46, !48, !50, !72, !80, !92, !100, !112, !120, !129}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !22, line: 44, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "src/HelloWorld.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "36f17d6f81e8de0d822e68a3b033ea2d")
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 1200, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 150)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !22, line: 51, type: !23, isLocal: true, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !22, line: 56, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 4)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !22, line: 57, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 48, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 6)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !22, line: 58, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 40, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 5)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !22, line: 63, type: !23, isLocal: true, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !22, line: 70, type: !23, isLocal: true, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !22, line: 99, type: !23, isLocal: true, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !52, line: 19, type: !53, isLocal: false, isDefinition: true)
!52 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_structures.bpf.h", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "c2bd38c05cd37ff863c88000051eef3c")
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 13, size: 256, elements: !54)
!54 = !{!55, !59, !64, !67}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !53, file: !52, line: 15, baseType: !56, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 192, elements: !37)
!58 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !53, file: !52, line: 16, baseType: !60, size: 64, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 32, elements: !62)
!62 = !{!63}
!63 = !DISubrange(count: 1)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !53, file: !52, line: 17, baseType: !65, size: 64, offset: 128)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 128, elements: !32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !53, file: !52, line: 18, baseType: !68, size: 64, offset: 192)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 16000, elements: !70)
!70 = !{!71}
!71 = !DISubrange(count: 500)
!72 = !DIGlobalVariableExpression(var: !73, expr: !DIExpression())
!73 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !52, line: 27, type: !74, isLocal: false, isDefinition: true)
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 21, size: 256, elements: !75)
!75 = !{!76, !77, !78, !79}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !74, file: !52, line: 23, baseType: !56, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !74, file: !52, line: 24, baseType: !60, size: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !74, file: !52, line: 25, baseType: !65, size: 64, offset: 128)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !74, file: !52, line: 26, baseType: !65, size: 64, offset: 192)
!80 = !DIGlobalVariableExpression(var: !81, expr: !DIExpression())
!81 = distinct !DIGlobalVariable(name: "tuple_pool_map", scope: !2, file: !52, line: 36, type: !82, isLocal: false, isDefinition: true)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 30, size: 256, elements: !83)
!83 = !{!84, !85, !86, !87}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !82, file: !52, line: 32, baseType: !56, size: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !82, file: !52, line: 33, baseType: !60, size: 64, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !82, file: !52, line: 34, baseType: !65, size: 64, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !82, file: !52, line: 35, baseType: !88, size: 64, offset: 192)
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 64000, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 2000)
!92 = !DIGlobalVariableExpression(var: !93, expr: !DIExpression())
!93 = distinct !DIGlobalVariable(name: "tuple_pool_index_map", scope: !2, file: !52, line: 44, type: !94, isLocal: false, isDefinition: true)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 38, size: 256, elements: !95)
!95 = !{!96, !97, !98, !99}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !94, file: !52, line: 40, baseType: !56, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !94, file: !52, line: 41, baseType: !60, size: 64, offset: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !94, file: !52, line: 42, baseType: !65, size: 64, offset: 128)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !94, file: !52, line: 43, baseType: !65, size: 64, offset: 192)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !52, line: 53, type: !102, isLocal: false, isDefinition: true)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 47, size: 256, elements: !103)
!103 = !{!104, !105, !106, !107}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !102, file: !52, line: 49, baseType: !56, size: 64)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !102, file: !52, line: 50, baseType: !60, size: 64, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !102, file: !52, line: 51, baseType: !65, size: 64, offset: 128)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !102, file: !52, line: 52, baseType: !108, size: 64, offset: 192)
!108 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !109, size: 64)
!109 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 76800, elements: !110)
!110 = !{!111}
!111 = !DISubrange(count: 2400)
!112 = !DIGlobalVariableExpression(var: !113, expr: !DIExpression())
!113 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !52, line: 61, type: !114, isLocal: false, isDefinition: true)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !52, line: 55, size: 256, elements: !115)
!115 = !{!116, !117, !118, !119}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !114, file: !52, line: 57, baseType: !56, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !114, file: !52, line: 58, baseType: !60, size: 64, offset: 64)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !114, file: !52, line: 59, baseType: !65, size: 64, offset: 128)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !114, file: !52, line: 60, baseType: !65, size: 64, offset: 192)
!120 = !DIGlobalVariableExpression(var: !121, expr: !DIExpression())
!121 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !122, line: 50, type: !123, isLocal: true, isDefinition: true)
!122 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "eadf4a8bcf7ac4e7bd6d2cb666452242")
!123 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!124 = !DISubroutineType(types: !125)
!125 = !{!126, !126, !127}
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!129 = !DIGlobalVariableExpression(var: !130, expr: !DIExpression())
!130 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !122, line: 171, type: !131, isLocal: true, isDefinition: true)
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!132 = !DISubroutineType(types: !133)
!133 = !{!134, !135, !137, null}
!134 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!137 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !138, line: 27, baseType: !7)
!138 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!139 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 104, elements: !140)
!140 = !{!141}
!141 = !DISubrange(count: 13)
!142 = !{i32 7, !"Dwarf Version", i32 5}
!143 = !{i32 2, !"Debug Info Version", i32 3}
!144 = !{i32 1, !"wchar_size", i32 4}
!145 = !{i32 7, !"frame-pointer", i32 2}
!146 = !{!"Homebrew clang version 15.0.7"}
!147 = distinct !DISubprogram(name: "main_func", scope: !22, file: !22, line: 32, type: !148, scopeLine: 32, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !167)
!148 = !DISubroutineType(types: !149)
!149 = !{!58, !150}
!150 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "syscalls_enter_write_args", file: !22, line: 25, baseType: !152)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_write_args", file: !22, line: 11, size: 256, elements: !153)
!153 = !{!154, !156, !158, !159, !160, !161, !162, !163}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "common_type", scope: !152, file: !22, line: 17, baseType: !155, size: 16)
!155 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "common_flags", scope: !152, file: !22, line: 18, baseType: !157, size: 8, offset: 16)
!157 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "common_preempt_count", scope: !152, file: !22, line: 19, baseType: !157, size: 8, offset: 24)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "common_pid", scope: !152, file: !22, line: 20, baseType: !58, size: 32, offset: 32)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "__syscall_nr", scope: !152, file: !22, line: 21, baseType: !58, size: 32, offset: 64)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "fd", scope: !152, file: !22, line: 22, baseType: !7, size: 32, offset: 96)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !152, file: !22, line: 23, baseType: !135, size: 64, offset: 128)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "count", scope: !152, file: !22, line: 24, baseType: !164, size: 64, offset: 192)
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !165, line: 46, baseType: !166)
!165 = !DIFile(filename: "linuxbrew/.linuxbrew/Cellar/llvm@15/15.0.7/lib/clang/15.0.7/include/stddef.h", directory: "/home", checksumkind: CSK_MD5, checksum: "b76978376d35d5cd171876ac58ac1256")
!166 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!167 = !{!168, !169, !177, !178, !179, !219, !220, !223, !225, !230, !231, !234, !235, !236, !238, !239, !244}
!168 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !147, file: !22, line: 32, type: !150)
!169 = !DILocalVariable(name: "str_param1", scope: !147, file: !22, line: 34, type: !170)
!170 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 105, baseType: !171)
!171 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 102, size: 16, elements: !172)
!172 = !{!173}
!173 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !171, file: !6, line: 104, baseType: !174, size: 16)
!174 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16, elements: !175)
!175 = !{!176}
!176 = !DISubrange(count: 2)
!177 = !DILocalVariable(name: "str_param2", scope: !147, file: !22, line: 35, type: !170)
!178 = !DILocalVariable(name: "str_param3", scope: !147, file: !22, line: 36, type: !170)
!179 = !DILocalVariable(name: "op_result", scope: !147, file: !22, line: 38, type: !180)
!180 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !6, line: 100, baseType: !181)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !6, line: 95, size: 1472, elements: !182)
!182 = !{!183, !217, !218}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !181, file: !6, line: 97, baseType: !184, size: 192)
!184 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !6, line: 93, baseType: !185)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !6, line: 89, size: 192, elements: !186)
!186 = !{!187, !189}
!187 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !185, file: !6, line: 91, baseType: !188, size: 32)
!188 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !6, line: 52, baseType: !5)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !185, file: !6, line: 92, baseType: !190, size: 128, offset: 64)
!190 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !6, line: 87, baseType: !191)
!191 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !6, line: 79, size: 128, elements: !192)
!192 = !{!193, !194, !195, !197, !203, !209}
!193 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !191, file: !6, line: 81, baseType: !134, size: 64)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "u_integer", scope: !191, file: !6, line: 82, baseType: !7, size: 32)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "double_precision", scope: !191, file: !6, line: 83, baseType: !196, size: 64)
!196 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !191, file: !6, line: 84, baseType: !198, size: 64)
!198 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !6, line: 58, baseType: !199)
!199 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !6, line: 54, size: 64, elements: !200)
!200 = !{!201, !202}
!201 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !199, file: !6, line: 56, baseType: !58, size: 32)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !199, file: !6, line: 57, baseType: !58, size: 32, offset: 32)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !191, file: !6, line: 85, baseType: !204, size: 64)
!204 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !6, line: 64, baseType: !205)
!205 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !6, line: 60, size: 64, elements: !206)
!206 = !{!207, !208}
!207 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !205, file: !6, line: 62, baseType: !58, size: 32)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !205, file: !6, line: 63, baseType: !58, size: 32, offset: 32)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "syscalls_enter_kill_args", scope: !191, file: !6, line: 86, baseType: !210, size: 128)
!210 = !DIDerivedType(tag: DW_TAG_typedef, name: "struct_Syscalls_enter_kill_args", file: !6, line: 77, baseType: !211)
!211 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "struct_Syscalls_enter_kill_args", file: !6, line: 71, size: 128, elements: !212)
!212 = !{!213, !214, !215, !216}
!213 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pad", scope: !211, file: !6, line: 73, baseType: !7, size: 32)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "pos_syscall_nr", scope: !211, file: !6, line: 74, baseType: !7, size: 32, offset: 32)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pid", scope: !211, file: !6, line: 75, baseType: !7, size: 32, offset: 64)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "pos_sig", scope: !211, file: !6, line: 76, baseType: !7, size: 32, offset: 96)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !181, file: !6, line: 98, baseType: !58, size: 32, offset: 192)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !181, file: !6, line: 99, baseType: !23, size: 1200, offset: 224)
!219 = !DILocalVariable(name: "zero", scope: !147, file: !22, line: 40, type: !58)
!220 = !DILocalVariable(name: "string_pool", scope: !147, file: !22, line: 41, type: !221)
!221 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !222, size: 64)
!222 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 4000, elements: !70)
!223 = !DILocalVariable(name: "string_pool_index", scope: !147, file: !22, line: 48, type: !224)
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!225 = !DILocalVariable(name: "heap", scope: !147, file: !22, line: 60, type: !226)
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !227, size: 64)
!227 = !DICompositeType(tag: DW_TAG_array_type, baseType: !184, size: 19200, elements: !228)
!228 = !{!229}
!229 = !DISubrange(count: 100)
!230 = !DILocalVariable(name: "heap_index", scope: !147, file: !22, line: 67, type: !224)
!231 = !DILocalVariable(name: "tuple_pool", scope: !147, file: !22, line: 75, type: !232)
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !233, size: 64)
!233 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 16000, elements: !70)
!234 = !DILocalVariable(name: "tuple_pool_index", scope: !147, file: !22, line: 82, type: !224)
!235 = !DILocalVariable(name: "helper_var_11", scope: !147, file: !22, line: 92, type: !184)
!236 = !DILocalVariable(name: "____fmt", scope: !237, file: !22, line: 93, type: !139)
!237 = distinct !DILexicalBlock(scope: !147, file: !22, line: 93, column: 1)
!238 = !DILocalVariable(name: "helper_var_1027", scope: !147, file: !22, line: 94, type: !184)
!239 = !DILocalVariable(name: "____fmt", scope: !240, file: !22, line: 105, type: !241)
!240 = distinct !DILexicalBlock(scope: !147, file: !22, line: 105, column: 3)
!241 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 56, elements: !242)
!242 = !{!243}
!243 = !DISubrange(count: 7)
!244 = !DILabel(scope: !147, name: "CATCH", file: !22, line: 104)
!245 = !DILocation(line: 34, column: 15, scope: !147)
!246 = !DILocation(line: 35, column: 15, scope: !147)
!247 = !DILocation(line: 36, column: 15, scope: !147)
!248 = !DILocation(line: 0, scope: !147)
!249 = !DILocation(line: 38, column: 1, scope: !147)
!250 = !DILocation(line: 38, column: 10, scope: !147)
!251 = !DILocation(line: 40, column: 1, scope: !147)
!252 = !DILocation(line: 40, column: 5, scope: !147)
!253 = !{!254, !254, i64 0}
!254 = !{!"int", !255, i64 0}
!255 = !{!"omnipotent char", !256, i64 0}
!256 = !{!"Simple C/C++ TBAA"}
!257 = !DILocation(line: 41, column: 40, scope: !147)
!258 = !DILocation(line: 42, column: 6, scope: !259)
!259 = distinct !DILexicalBlock(scope: !147, file: !22, line: 42, column: 5)
!260 = !DILocation(line: 42, column: 5, scope: !147)
!261 = !DILocation(line: 44, column: 25, scope: !262)
!262 = distinct !DILexicalBlock(scope: !259, file: !22, line: 43, column: 1)
!263 = !DILocation(line: 44, column: 15, scope: !262)
!264 = !{i64 0, i64 4, !253, i64 4, i64 150, !265}
!265 = !{!255, !255, i64 0}
!266 = !{i64 0, i64 150, !265}
!267 = !DILocation(line: 45, column: 3, scope: !262)
!268 = !DILocation(line: 48, column: 31, scope: !147)
!269 = !DILocation(line: 49, column: 6, scope: !270)
!270 = distinct !DILexicalBlock(scope: !147, file: !22, line: 49, column: 5)
!271 = !DILocation(line: 49, column: 5, scope: !147)
!272 = !DILocation(line: 51, column: 25, scope: !273)
!273 = distinct !DILexicalBlock(scope: !270, file: !22, line: 50, column: 1)
!274 = !DILocation(line: 51, column: 15, scope: !273)
!275 = !DILocation(line: 52, column: 3, scope: !273)
!276 = !DILocation(line: 54, column: 20, scope: !147)
!277 = !DILocation(line: 56, column: 1, scope: !147)
!278 = !DILocation(line: 57, column: 31, scope: !147)
!279 = !DILocation(line: 57, column: 1, scope: !147)
!280 = !DILocation(line: 58, column: 35, scope: !147)
!281 = !DILocation(line: 58, column: 1, scope: !147)
!282 = !DILocation(line: 60, column: 29, scope: !147)
!283 = !DILocation(line: 61, column: 6, scope: !284)
!284 = distinct !DILexicalBlock(scope: !147, file: !22, line: 61, column: 5)
!285 = !DILocation(line: 61, column: 5, scope: !147)
!286 = !DILocation(line: 63, column: 25, scope: !287)
!287 = distinct !DILexicalBlock(scope: !284, file: !22, line: 62, column: 1)
!288 = !DILocation(line: 63, column: 15, scope: !287)
!289 = !DILocation(line: 64, column: 3, scope: !287)
!290 = !DILocation(line: 67, column: 24, scope: !147)
!291 = !DILocation(line: 68, column: 6, scope: !292)
!292 = distinct !DILexicalBlock(scope: !147, file: !22, line: 68, column: 5)
!293 = !DILocation(line: 68, column: 5, scope: !147)
!294 = !DILocation(line: 70, column: 25, scope: !295)
!295 = distinct !DILexicalBlock(scope: !292, file: !22, line: 69, column: 1)
!296 = !DILocation(line: 70, column: 15, scope: !295)
!297 = !DILocation(line: 71, column: 3, scope: !295)
!298 = !DILocation(line: 73, column: 13, scope: !147)
!299 = !DILocation(line: 75, column: 43, scope: !147)
!300 = !DILocation(line: 76, column: 6, scope: !301)
!301 = distinct !DILexicalBlock(scope: !147, file: !22, line: 76, column: 5)
!302 = !DILocation(line: 76, column: 5, scope: !147)
!303 = !DILocation(line: 78, column: 25, scope: !304)
!304 = distinct !DILexicalBlock(scope: !301, file: !22, line: 77, column: 1)
!305 = !DILocation(line: 78, column: 15, scope: !304)
!306 = !DILocation(line: 79, column: 3, scope: !304)
!307 = !DILocation(line: 82, column: 30, scope: !147)
!308 = !DILocation(line: 83, column: 6, scope: !309)
!309 = distinct !DILexicalBlock(scope: !147, file: !22, line: 83, column: 5)
!310 = !DILocation(line: 83, column: 5, scope: !147)
!311 = !DILocation(line: 85, column: 25, scope: !312)
!312 = distinct !DILexicalBlock(scope: !309, file: !22, line: 84, column: 1)
!313 = !DILocation(line: 85, column: 15, scope: !312)
!314 = !DILocation(line: 86, column: 3, scope: !312)
!315 = !DILocation(line: 88, column: 19, scope: !147)
!316 = !DILocation(line: 93, column: 1, scope: !237)
!317 = !DILocation(line: 93, column: 1, scope: !147)
!318 = !DILocation(line: 102, column: 1, scope: !147)
!319 = !DILocation(line: 104, column: 1, scope: !147)
!320 = !DILocation(line: 105, column: 3, scope: !240)
!321 = !DILocation(line: 105, column: 3, scope: !147)
!322 = !DILocation(line: 106, column: 3, scope: !147)
!323 = !DILocation(line: 108, column: 1, scope: !147)
