; ModuleID = '/home/vinicius/honey-potion/test_cases/lib/src/Case.bpf.c'
source_filename = "/home/vinicius/honey-potion/test_cases/lib/src/Case.bpf.c"
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
@string_pool_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !54
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !20
@string_pool_index_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !76
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !27
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1, !dbg !29
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1, !dbg !34
@heap_map = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !104
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !44
@heap_index_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !116
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !46
@tuple_pool_map = dso_local global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !84
@tuple_pool_index_map = dso_local global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !96
@.str.7 = private unnamed_addr constant [150 x i8] c"(MatchError) No match of right hand side value.\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !48
@__const.main_func.____fmt = private unnamed_addr constant [11 x i8] c"Result: %d\00", align 1
@__const.main_func.____fmt.10 = private unnamed_addr constant [7 x i8] c"** %s\0A\00", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @LICENSE, ptr @heap_index_map, ptr @heap_map, ptr @main_func, ptr @string_pool_index_map, ptr @string_pool_map, ptr @tuple_pool_index_map, ptr @tuple_pool_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(ptr nocapture readnone %0) #0 section "tracepoint/raw_syscalls/sys_enter" !dbg !160 {
  call void @llvm.dbg.declare(metadata ptr undef, metadata !179, metadata !DIExpression()), !dbg !289
  call void @llvm.dbg.declare(metadata ptr undef, metadata !187, metadata !DIExpression()), !dbg !290
  call void @llvm.dbg.declare(metadata ptr undef, metadata !188, metadata !DIExpression()), !dbg !291
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  %4 = alloca [11 x i8], align 1
  %5 = alloca [7 x i8], align 1
  call void @llvm.dbg.value(metadata ptr poison, metadata !178, metadata !DIExpression()), !dbg !292
  call void @llvm.lifetime.start.p0(i64 184, ptr nonnull %2) #6, !dbg !293
  call void @llvm.dbg.declare(metadata ptr %2, metadata !189, metadata !DIExpression()), !dbg !294
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(184) %2, i8 0, i64 184, i1 false), !dbg !294
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6, !dbg !295
  call void @llvm.dbg.value(metadata i32 0, metadata !229, metadata !DIExpression()), !dbg !292
  store i32 0, ptr %3, align 4, !dbg !296, !tbaa !297
  call void @llvm.dbg.value(metadata ptr %3, metadata !229, metadata !DIExpression(DW_OP_deref)), !dbg !292
  %6 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %3) #6, !dbg !301
  call void @llvm.dbg.value(metadata ptr %6, metadata !230, metadata !DIExpression()), !dbg !292
  %7 = icmp eq ptr %6, null, !dbg !302
  br i1 %7, label %8, label %11, !dbg !304

8:                                                ; preds = %1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !305
  %9 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !307
  store i32 1, ptr %9, align 8, !dbg !307, !tbaa.struct !308
  %10 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !307
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %10, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !307, !tbaa.struct !310
  br label %47, !dbg !311

11:                                               ; preds = %1
  call void @llvm.dbg.value(metadata ptr %3, metadata !229, metadata !DIExpression(DW_OP_deref)), !dbg !292
  %12 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_index_map, ptr noundef nonnull %3) #6, !dbg !312
  call void @llvm.dbg.value(metadata ptr %12, metadata !233, metadata !DIExpression()), !dbg !292
  %13 = icmp eq ptr %12, null, !dbg !313
  br i1 %13, label %14, label %17, !dbg !315

14:                                               ; preds = %11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !316
  %15 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !318
  store i32 1, ptr %15, align 8, !dbg !318, !tbaa.struct !308
  %16 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !318
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %16, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !318, !tbaa.struct !310
  br label %47, !dbg !319

17:                                               ; preds = %11
  store i32 0, ptr %12, align 4, !dbg !320, !tbaa !297
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %6, ptr noundef nonnull align 1 dereferenceable(3) @.str.2, i64 3, i1 false), !dbg !321
  %18 = getelementptr inbounds i8, ptr %6, i64 3, !dbg !322
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %18, ptr noundef nonnull align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !dbg !323
  %19 = getelementptr inbounds i8, ptr %6, i64 8, !dbg !324
  store i32 1702195828, ptr %19, align 1, !dbg !325
  call void @llvm.dbg.value(metadata ptr %3, metadata !229, metadata !DIExpression(DW_OP_deref)), !dbg !292
  %20 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_map, ptr noundef nonnull %3) #6, !dbg !326
  call void @llvm.dbg.value(metadata ptr %20, metadata !235, metadata !DIExpression()), !dbg !292
  %21 = icmp eq ptr %20, null, !dbg !327
  br i1 %21, label %22, label %25, !dbg !329

22:                                               ; preds = %17
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !330
  %23 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !332
  store i32 1, ptr %23, align 8, !dbg !332, !tbaa.struct !308
  %24 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !332
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %24, ptr noundef nonnull align 4 dereferenceable(150) @.str.5, i64 150, i1 false), !dbg !332, !tbaa.struct !310
  br label %47, !dbg !333

25:                                               ; preds = %17
  call void @llvm.dbg.value(metadata ptr %3, metadata !229, metadata !DIExpression(DW_OP_deref)), !dbg !292
  %26 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_index_map, ptr noundef nonnull %3) #6, !dbg !334
  call void @llvm.dbg.value(metadata ptr %26, metadata !240, metadata !DIExpression()), !dbg !292
  %27 = icmp eq ptr %26, null, !dbg !335
  br i1 %27, label %28, label %31, !dbg !337

28:                                               ; preds = %25
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !338
  %29 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !340
  store i32 1, ptr %29, align 8, !dbg !340, !tbaa.struct !308
  %30 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !340
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %30, ptr noundef nonnull align 4 dereferenceable(150) @.str.6, i64 150, i1 false), !dbg !340, !tbaa.struct !310
  br label %47, !dbg !341

31:                                               ; preds = %25
  store i32 0, ptr %26, align 4, !dbg !342, !tbaa !297
  call void @llvm.dbg.value(metadata ptr %3, metadata !229, metadata !DIExpression(DW_OP_deref)), !dbg !292
  %32 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_map, ptr noundef nonnull %3) #6, !dbg !343
  call void @llvm.dbg.value(metadata ptr %32, metadata !241, metadata !DIExpression()), !dbg !292
  %33 = icmp eq ptr %32, null, !dbg !344
  br i1 %33, label %34, label %37, !dbg !346

34:                                               ; preds = %31
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !347
  %35 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !349
  store i32 1, ptr %35, align 8, !dbg !349, !tbaa.struct !308
  %36 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !349
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %36, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !349, !tbaa.struct !310
  br label %47, !dbg !350

37:                                               ; preds = %31
  call void @llvm.dbg.value(metadata ptr %3, metadata !229, metadata !DIExpression(DW_OP_deref)), !dbg !292
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_index_map, ptr noundef nonnull %3) #6, !dbg !351
  call void @llvm.dbg.value(metadata ptr %38, metadata !244, metadata !DIExpression()), !dbg !292
  %39 = icmp eq ptr %38, null, !dbg !352
  br i1 %39, label %40, label %43, !dbg !354

40:                                               ; preds = %37
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !355
  %41 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !357
  store i32 1, ptr %41, align 8, !dbg !357, !tbaa.struct !308
  %42 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !357
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %42, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !357, !tbaa.struct !310
  br label %47, !dbg !358

43:                                               ; preds = %37
  store i32 0, ptr %38, align 4, !dbg !359, !tbaa !297
  %44 = getelementptr inbounds %struct.OpResult, ptr %2, i64 0, i32 1, !dbg !360
  call void @llvm.dbg.value(metadata i32 2, metadata !246, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i32 undef, metadata !246, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i32 1, metadata !246, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i32 0, metadata !246, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i64 undef, metadata !246, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !292
  call void @llvm.dbg.label(metadata !281), !dbg !361
  %45 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !362
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %45, ptr noundef nonnull align 4 dereferenceable(150) @.str.7, i64 150, i1 false), !dbg !362, !tbaa.struct !310
  call void @llvm.dbg.label(metadata !282), !dbg !365
  store i32 1, ptr %44, align 8, !dbg !366, !tbaa.struct !308
  call void @llvm.dbg.label(metadata !283), !dbg !369
  call void @llvm.dbg.label(metadata !284), !dbg !370
  call void @llvm.dbg.label(metadata !285), !dbg !371
  call void @llvm.dbg.label(metadata !286), !dbg !372
  call void @llvm.dbg.value(metadata i32 2, metadata !264, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !373
  call void @llvm.dbg.value(metadata i32 undef, metadata !264, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !373
  call void @llvm.dbg.value(metadata i64 1, metadata !264, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !373
  call void @llvm.dbg.value(metadata i64 undef, metadata !264, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !373
  call void @llvm.dbg.value(metadata ptr %2, metadata !374, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata ptr undef, metadata !381, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata ptr undef, metadata !382, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata i32 0, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i32 undef, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i64 undef, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !292
  call void @llvm.dbg.value(metadata i64 undef, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !292
  call void @llvm.dbg.value(metadata i32 0, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i32 undef, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i64 undef, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !292
  call void @llvm.dbg.value(metadata i64 2, metadata !247, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !292
  call void @llvm.dbg.value(metadata !DIArgList(i64 0, i32 undef), metadata !269, metadata !DIExpression(DW_OP_LLVM_arg, 0, DW_OP_LLVM_arg, 1, DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_or, DW_OP_stack_value, DW_OP_LLVM_fragment, 0, 64)), !dbg !292
  call void @llvm.dbg.value(metadata i64 2, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !292
  call void @llvm.dbg.value(metadata i64 undef, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !292
  call void @llvm.dbg.label(metadata !287), !dbg !385
  call void @llvm.lifetime.start.p0(i64 11, ptr nonnull %4) #6, !dbg !386
  call void @llvm.dbg.declare(metadata ptr %4, metadata !270, metadata !DIExpression()), !dbg !386
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(11) %4, ptr noundef nonnull align 1 dereferenceable(11) @__const.main_func.____fmt, i64 11, i1 false), !dbg !386
  %46 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %4, i32 noundef 11, i64 noundef 2) #6, !dbg !386
  call void @llvm.lifetime.end.p0(i64 11, ptr nonnull %4) #6, !dbg !387
  call void @llvm.dbg.value(metadata i32 2, metadata !275, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i32 undef, metadata !275, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !292
  call void @llvm.dbg.value(metadata i64 0, metadata !275, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !292
  call void @llvm.dbg.value(metadata i64 undef, metadata !275, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !292
  br label %50, !dbg !388

47:                                               ; preds = %40, %34, %28, %22, %14, %8
  call void @llvm.dbg.label(metadata !288), !dbg !389
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %5) #6, !dbg !390
  call void @llvm.dbg.declare(metadata ptr %5, metadata !276, metadata !DIExpression()), !dbg !390
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %5, ptr noundef nonnull align 1 dereferenceable(7) @__const.main_func.____fmt.10, i64 7, i1 false), !dbg !390
  %48 = getelementptr inbounds %struct.OpResult, ptr %2, i64 0, i32 2, !dbg !390
  %49 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %5, i32 noundef 7, ptr noundef nonnull %48) #6, !dbg !390
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %5) #6, !dbg !391
  br label %50, !dbg !392

50:                                               ; preds = %47, %43
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6, !dbg !393
  call void @llvm.lifetime.end.p0(i64 184, ptr nonnull %2) #6, !dbg !393
  ret i32 0, !dbg !393
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn writeonly
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nocallback nofree nounwind willreturn
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

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
!llvm.module.flags = !{!155, !156, !157, !158}
!llvm.ident = !{!159}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !22, line: 25, type: !152, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/vinicius/honey-potion/test_cases/lib/src/Case.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "2070bda9966a5b7c56c4b7824a40c3cb")
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
!19 = !{!0, !20, !27, !29, !34, !39, !44, !46, !48, !50, !52, !54, !76, !84, !96, !104, !116, !124, !133, !136, !138, !140, !142}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !22, line: 42, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "src/Case.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "2070bda9966a5b7c56c4b7824a40c3cb")
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 1200, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 150)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(scope: null, file: !22, line: 49, type: !23, isLocal: true, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !22, line: 54, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 4)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(scope: null, file: !22, line: 55, type: !36, isLocal: true, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 48, elements: !37)
!37 = !{!38}
!38 = !DISubrange(count: 6)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(scope: null, file: !22, line: 56, type: !41, isLocal: true, isDefinition: true)
!41 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 40, elements: !42)
!42 = !{!43}
!43 = !DISubrange(count: 5)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(scope: null, file: !22, line: 61, type: !23, isLocal: true, isDefinition: true)
!46 = !DIGlobalVariableExpression(var: !47, expr: !DIExpression())
!47 = distinct !DIGlobalVariable(scope: null, file: !22, line: 68, type: !23, isLocal: true, isDefinition: true)
!48 = !DIGlobalVariableExpression(var: !49, expr: !DIExpression())
!49 = distinct !DIGlobalVariable(scope: null, file: !22, line: 107, type: !23, isLocal: true, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !22, line: 184, type: !23, isLocal: true, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !22, line: 215, type: !23, isLocal: true, isDefinition: true)
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !56, line: 19, type: !57, isLocal: false, isDefinition: true)
!56 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_structures.bpf.h", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "c2bd38c05cd37ff863c88000051eef3c")
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !56, line: 13, size: 256, elements: !58)
!58 = !{!59, !63, !68, !71}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !57, file: !56, line: 15, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 192, elements: !37)
!62 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !57, file: !56, line: 16, baseType: !64, size: 64, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 32, elements: !66)
!66 = !{!67}
!67 = !DISubrange(count: 1)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !57, file: !56, line: 17, baseType: !69, size: 64, offset: 128)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 128, elements: !32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !57, file: !56, line: 18, baseType: !72, size: 64, offset: 192)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 16000, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 500)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !56, line: 27, type: !78, isLocal: false, isDefinition: true)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !56, line: 21, size: 256, elements: !79)
!79 = !{!80, !81, !82, !83}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !78, file: !56, line: 23, baseType: !60, size: 64)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !78, file: !56, line: 24, baseType: !64, size: 64, offset: 64)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !78, file: !56, line: 25, baseType: !69, size: 64, offset: 128)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !78, file: !56, line: 26, baseType: !69, size: 64, offset: 192)
!84 = !DIGlobalVariableExpression(var: !85, expr: !DIExpression())
!85 = distinct !DIGlobalVariable(name: "tuple_pool_map", scope: !2, file: !56, line: 36, type: !86, isLocal: false, isDefinition: true)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !56, line: 30, size: 256, elements: !87)
!87 = !{!88, !89, !90, !91}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !86, file: !56, line: 32, baseType: !60, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !86, file: !56, line: 33, baseType: !64, size: 64, offset: 64)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !86, file: !56, line: 34, baseType: !69, size: 64, offset: 128)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !86, file: !56, line: 35, baseType: !92, size: 64, offset: 192)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 64)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 64000, elements: !94)
!94 = !{!95}
!95 = !DISubrange(count: 2000)
!96 = !DIGlobalVariableExpression(var: !97, expr: !DIExpression())
!97 = distinct !DIGlobalVariable(name: "tuple_pool_index_map", scope: !2, file: !56, line: 44, type: !98, isLocal: false, isDefinition: true)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !56, line: 38, size: 256, elements: !99)
!99 = !{!100, !101, !102, !103}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !98, file: !56, line: 40, baseType: !60, size: 64)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !98, file: !56, line: 41, baseType: !64, size: 64, offset: 64)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !98, file: !56, line: 42, baseType: !69, size: 64, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !98, file: !56, line: 43, baseType: !69, size: 64, offset: 192)
!104 = !DIGlobalVariableExpression(var: !105, expr: !DIExpression())
!105 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !56, line: 53, type: !106, isLocal: false, isDefinition: true)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !56, line: 47, size: 256, elements: !107)
!107 = !{!108, !109, !110, !111}
!108 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !106, file: !56, line: 49, baseType: !60, size: 64)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !106, file: !56, line: 50, baseType: !64, size: 64, offset: 64)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !106, file: !56, line: 51, baseType: !69, size: 64, offset: 128)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !106, file: !56, line: 52, baseType: !112, size: 64, offset: 192)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 76800, elements: !114)
!114 = !{!115}
!115 = !DISubrange(count: 2400)
!116 = !DIGlobalVariableExpression(var: !117, expr: !DIExpression())
!117 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !56, line: 61, type: !118, isLocal: false, isDefinition: true)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !56, line: 55, size: 256, elements: !119)
!119 = !{!120, !121, !122, !123}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !118, file: !56, line: 57, baseType: !60, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !118, file: !56, line: 58, baseType: !64, size: 64, offset: 64)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !118, file: !56, line: 59, baseType: !69, size: 64, offset: 128)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !118, file: !56, line: 60, baseType: !69, size: 64, offset: 192)
!124 = !DIGlobalVariableExpression(var: !125, expr: !DIExpression())
!125 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !126, line: 50, type: !127, isLocal: true, isDefinition: true)
!126 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "eadf4a8bcf7ac4e7bd6d2cb666452242")
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DISubroutineType(types: !129)
!129 = !{!130, !130, !131}
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!132 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!133 = !DIGlobalVariableExpression(var: !134, expr: !DIExpression())
!134 = distinct !DIGlobalVariable(scope: null, file: !135, line: 109, type: !23, isLocal: true, isDefinition: true)
!135 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_functions.bpf.c", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "b230f5be759074326648f496f90fd18a")
!136 = !DIGlobalVariableExpression(var: !137, expr: !DIExpression())
!137 = distinct !DIGlobalVariable(scope: null, file: !135, line: 120, type: !23, isLocal: true, isDefinition: true)
!138 = !DIGlobalVariableExpression(var: !139, expr: !DIExpression())
!139 = distinct !DIGlobalVariable(scope: null, file: !135, line: 126, type: !23, isLocal: true, isDefinition: true)
!140 = !DIGlobalVariableExpression(var: !141, expr: !DIExpression())
!141 = distinct !DIGlobalVariable(scope: null, file: !135, line: 136, type: !23, isLocal: true, isDefinition: true)
!142 = !DIGlobalVariableExpression(var: !143, expr: !DIExpression())
!143 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !126, line: 171, type: !144, isLocal: true, isDefinition: true)
!144 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!145 = !DISubroutineType(types: !146)
!146 = !{!147, !148, !150, null}
!147 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!148 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !149, size: 64)
!149 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!150 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !151, line: 27, baseType: !7)
!151 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!152 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 104, elements: !153)
!153 = !{!154}
!154 = !DISubrange(count: 13)
!155 = !{i32 7, !"Dwarf Version", i32 5}
!156 = !{i32 2, !"Debug Info Version", i32 3}
!157 = !{i32 1, !"wchar_size", i32 4}
!158 = !{i32 7, !"frame-pointer", i32 2}
!159 = !{!"Homebrew clang version 15.0.7"}
!160 = distinct !DISubprogram(name: "main_func", scope: !22, file: !22, line: 30, type: !161, scopeLine: 30, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !177)
!161 = !DISubroutineType(types: !162)
!162 = !{!62, !163}
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = !DIDerivedType(tag: DW_TAG_typedef, name: "syscalls_enter_args", file: !22, line: 23, baseType: !165)
!165 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_args", file: !22, line: 11, size: 512, elements: !166)
!166 = !{!167, !169, !171, !172, !173, !174}
!167 = !DIDerivedType(tag: DW_TAG_member, name: "common_type", scope: !165, file: !22, line: 17, baseType: !168, size: 16)
!168 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "common_flags", scope: !165, file: !22, line: 18, baseType: !170, size: 8, offset: 16)
!170 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "common_preempt_count", scope: !165, file: !22, line: 19, baseType: !170, size: 8, offset: 24)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "common_pid", scope: !165, file: !22, line: 20, baseType: !62, size: 32, offset: 32)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !165, file: !22, line: 21, baseType: !147, size: 64, offset: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !165, file: !22, line: 22, baseType: !175, size: 384, offset: 128)
!175 = !DICompositeType(tag: DW_TAG_array_type, baseType: !176, size: 384, elements: !37)
!176 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!177 = !{!178, !179, !187, !188, !189, !229, !230, !233, !235, !240, !241, !244, !245, !246, !247, !248, !249, !252, !256, !260, !264, !268, !269, !270, !275, !276, !281, !282, !283, !284, !285, !286, !287, !288}
!178 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !160, file: !22, line: 30, type: !163)
!179 = !DILocalVariable(name: "str_param1", scope: !160, file: !22, line: 32, type: !180)
!180 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 105, baseType: !181)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 102, size: 16, elements: !182)
!182 = !{!183}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !181, file: !6, line: 104, baseType: !184, size: 16)
!184 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16, elements: !185)
!185 = !{!186}
!186 = !DISubrange(count: 2)
!187 = !DILocalVariable(name: "str_param2", scope: !160, file: !22, line: 33, type: !180)
!188 = !DILocalVariable(name: "str_param3", scope: !160, file: !22, line: 34, type: !180)
!189 = !DILocalVariable(name: "op_result", scope: !160, file: !22, line: 36, type: !190)
!190 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !6, line: 100, baseType: !191)
!191 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !6, line: 95, size: 1472, elements: !192)
!192 = !{!193, !227, !228}
!193 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !191, file: !6, line: 97, baseType: !194, size: 192)
!194 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !6, line: 93, baseType: !195)
!195 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !6, line: 89, size: 192, elements: !196)
!196 = !{!197, !199}
!197 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !195, file: !6, line: 91, baseType: !198, size: 32)
!198 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !6, line: 52, baseType: !5)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !195, file: !6, line: 92, baseType: !200, size: 128, offset: 64)
!200 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !6, line: 87, baseType: !201)
!201 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !6, line: 79, size: 128, elements: !202)
!202 = !{!203, !204, !205, !207, !213, !219}
!203 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !201, file: !6, line: 81, baseType: !147, size: 64)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "u_integer", scope: !201, file: !6, line: 82, baseType: !7, size: 32)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "double_precision", scope: !201, file: !6, line: 83, baseType: !206, size: 64)
!206 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !201, file: !6, line: 84, baseType: !208, size: 64)
!208 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !6, line: 58, baseType: !209)
!209 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !6, line: 54, size: 64, elements: !210)
!210 = !{!211, !212}
!211 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !209, file: !6, line: 56, baseType: !62, size: 32)
!212 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !209, file: !6, line: 57, baseType: !62, size: 32, offset: 32)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !201, file: !6, line: 85, baseType: !214, size: 64)
!214 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !6, line: 64, baseType: !215)
!215 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !6, line: 60, size: 64, elements: !216)
!216 = !{!217, !218}
!217 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !215, file: !6, line: 62, baseType: !62, size: 32)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !215, file: !6, line: 63, baseType: !62, size: 32, offset: 32)
!219 = !DIDerivedType(tag: DW_TAG_member, name: "syscalls_enter_kill_args", scope: !201, file: !6, line: 86, baseType: !220, size: 128)
!220 = !DIDerivedType(tag: DW_TAG_typedef, name: "struct_Syscalls_enter_kill_args", file: !6, line: 77, baseType: !221)
!221 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "struct_Syscalls_enter_kill_args", file: !6, line: 71, size: 128, elements: !222)
!222 = !{!223, !224, !225, !226}
!223 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pad", scope: !221, file: !6, line: 73, baseType: !7, size: 32)
!224 = !DIDerivedType(tag: DW_TAG_member, name: "pos_syscall_nr", scope: !221, file: !6, line: 74, baseType: !7, size: 32, offset: 32)
!225 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pid", scope: !221, file: !6, line: 75, baseType: !7, size: 32, offset: 64)
!226 = !DIDerivedType(tag: DW_TAG_member, name: "pos_sig", scope: !221, file: !6, line: 76, baseType: !7, size: 32, offset: 96)
!227 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !191, file: !6, line: 98, baseType: !62, size: 32, offset: 192)
!228 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !191, file: !6, line: 99, baseType: !23, size: 1200, offset: 224)
!229 = !DILocalVariable(name: "zero", scope: !160, file: !22, line: 38, type: !62)
!230 = !DILocalVariable(name: "string_pool", scope: !160, file: !22, line: 39, type: !231)
!231 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !232, size: 64)
!232 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 4000, elements: !74)
!233 = !DILocalVariable(name: "string_pool_index", scope: !160, file: !22, line: 46, type: !234)
!234 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!235 = !DILocalVariable(name: "heap", scope: !160, file: !22, line: 58, type: !236)
!236 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !237, size: 64)
!237 = !DICompositeType(tag: DW_TAG_array_type, baseType: !194, size: 19200, elements: !238)
!238 = !{!239}
!239 = !DISubrange(count: 100)
!240 = !DILocalVariable(name: "heap_index", scope: !160, file: !22, line: 65, type: !234)
!241 = !DILocalVariable(name: "tuple_pool", scope: !160, file: !22, line: 73, type: !242)
!242 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !243, size: 64)
!243 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 16000, elements: !74)
!244 = !DILocalVariable(name: "tuple_pool_index", scope: !160, file: !22, line: 80, type: !234)
!245 = !DILocalVariable(name: "helper_var_71", scope: !160, file: !22, line: 92, type: !194)
!246 = !DILocalVariable(name: "x_0_", scope: !160, file: !22, line: 94, type: !194)
!247 = !DILocalVariable(name: "helper_var_199", scope: !160, file: !22, line: 104, type: !194)
!248 = !DILocalVariable(name: "helper_var_391", scope: !160, file: !22, line: 111, type: !214)
!249 = !DILocalVariable(name: "helper_var_327", scope: !250, file: !22, line: 137, type: !194)
!250 = distinct !DILexicalBlock(scope: !251, file: !22, line: 136, column: 30)
!251 = distinct !DILexicalBlock(scope: !160, file: !22, line: 136, column: 4)
!252 = !DILocalVariable(name: "helper_var_519", scope: !253, file: !22, line: 148, type: !194)
!253 = distinct !DILexicalBlock(scope: !254, file: !22, line: 147, column: 30)
!254 = distinct !DILexicalBlock(scope: !255, file: !22, line: 147, column: 4)
!255 = distinct !DILexicalBlock(scope: !251, file: !22, line: 139, column: 8)
!256 = !DILocalVariable(name: "helper_var_647", scope: !257, file: !22, line: 159, type: !194)
!257 = distinct !DILexicalBlock(scope: !258, file: !22, line: 158, column: 30)
!258 = distinct !DILexicalBlock(scope: !259, file: !22, line: 158, column: 4)
!259 = distinct !DILexicalBlock(scope: !254, file: !22, line: 150, column: 8)
!260 = !DILocalVariable(name: "helper_var_775", scope: !261, file: !22, line: 170, type: !194)
!261 = distinct !DILexicalBlock(scope: !262, file: !22, line: 169, column: 30)
!262 = distinct !DILexicalBlock(scope: !263, file: !22, line: 169, column: 4)
!263 = distinct !DILexicalBlock(scope: !258, file: !22, line: 161, column: 8)
!264 = !DILocalVariable(name: "helper_var_903", scope: !265, file: !22, line: 179, type: !194)
!265 = distinct !DILexicalBlock(scope: !266, file: !22, line: 176, column: 30)
!266 = distinct !DILexicalBlock(scope: !267, file: !22, line: 176, column: 4)
!267 = distinct !DILexicalBlock(scope: !262, file: !22, line: 172, column: 8)
!268 = !DILocalVariable(name: "helper_var_967", scope: !265, file: !22, line: 180, type: !194)
!269 = !DILocalVariable(name: "return_1_", scope: !160, file: !22, line: 199, type: !194)
!270 = !DILocalVariable(name: "____fmt", scope: !271, file: !22, line: 208, type: !272)
!271 = distinct !DILexicalBlock(scope: !160, file: !22, line: 208, column: 1)
!272 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 88, elements: !273)
!273 = !{!274}
!274 = !DISubrange(count: 11)
!275 = !DILocalVariable(name: "helper_var_1031", scope: !160, file: !22, line: 209, type: !194)
!276 = !DILocalVariable(name: "____fmt", scope: !277, file: !22, line: 221, type: !278)
!277 = distinct !DILexicalBlock(scope: !160, file: !22, line: 221, column: 3)
!278 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 56, elements: !279)
!279 = !{!280}
!280 = !DISubrange(count: 7)
!281 = !DILabel(scope: !160, name: "label_7", file: !22, line: 96)
!282 = !DILabel(scope: !160, name: "label_263", file: !22, line: 135)
!283 = !DILabel(scope: !255, name: "label_455", file: !22, line: 146)
!284 = !DILabel(scope: !259, name: "label_583", file: !22, line: 157)
!285 = !DILabel(scope: !263, name: "label_711", file: !22, line: 168)
!286 = !DILabel(scope: !267, name: "label_839", file: !22, line: 175)
!287 = !DILabel(scope: !160, name: "label_135", file: !22, line: 201)
!288 = !DILabel(scope: !160, name: "CATCH", file: !22, line: 220)
!289 = !DILocation(line: 32, column: 15, scope: !160)
!290 = !DILocation(line: 33, column: 15, scope: !160)
!291 = !DILocation(line: 34, column: 15, scope: !160)
!292 = !DILocation(line: 0, scope: !160)
!293 = !DILocation(line: 36, column: 1, scope: !160)
!294 = !DILocation(line: 36, column: 10, scope: !160)
!295 = !DILocation(line: 38, column: 1, scope: !160)
!296 = !DILocation(line: 38, column: 5, scope: !160)
!297 = !{!298, !298, i64 0}
!298 = !{!"int", !299, i64 0}
!299 = !{!"omnipotent char", !300, i64 0}
!300 = !{!"Simple C/C++ TBAA"}
!301 = !DILocation(line: 39, column: 40, scope: !160)
!302 = !DILocation(line: 40, column: 6, scope: !303)
!303 = distinct !DILexicalBlock(scope: !160, file: !22, line: 40, column: 5)
!304 = !DILocation(line: 40, column: 5, scope: !160)
!305 = !DILocation(line: 42, column: 25, scope: !306)
!306 = distinct !DILexicalBlock(scope: !303, file: !22, line: 41, column: 1)
!307 = !DILocation(line: 42, column: 15, scope: !306)
!308 = !{i64 0, i64 4, !297, i64 4, i64 150, !309}
!309 = !{!299, !299, i64 0}
!310 = !{i64 0, i64 150, !309}
!311 = !DILocation(line: 43, column: 3, scope: !306)
!312 = !DILocation(line: 46, column: 31, scope: !160)
!313 = !DILocation(line: 47, column: 6, scope: !314)
!314 = distinct !DILexicalBlock(scope: !160, file: !22, line: 47, column: 5)
!315 = !DILocation(line: 47, column: 5, scope: !160)
!316 = !DILocation(line: 49, column: 25, scope: !317)
!317 = distinct !DILexicalBlock(scope: !314, file: !22, line: 48, column: 1)
!318 = !DILocation(line: 49, column: 15, scope: !317)
!319 = !DILocation(line: 50, column: 3, scope: !317)
!320 = !DILocation(line: 52, column: 20, scope: !160)
!321 = !DILocation(line: 54, column: 1, scope: !160)
!322 = !DILocation(line: 55, column: 31, scope: !160)
!323 = !DILocation(line: 55, column: 1, scope: !160)
!324 = !DILocation(line: 56, column: 35, scope: !160)
!325 = !DILocation(line: 56, column: 1, scope: !160)
!326 = !DILocation(line: 58, column: 29, scope: !160)
!327 = !DILocation(line: 59, column: 6, scope: !328)
!328 = distinct !DILexicalBlock(scope: !160, file: !22, line: 59, column: 5)
!329 = !DILocation(line: 59, column: 5, scope: !160)
!330 = !DILocation(line: 61, column: 25, scope: !331)
!331 = distinct !DILexicalBlock(scope: !328, file: !22, line: 60, column: 1)
!332 = !DILocation(line: 61, column: 15, scope: !331)
!333 = !DILocation(line: 62, column: 3, scope: !331)
!334 = !DILocation(line: 65, column: 24, scope: !160)
!335 = !DILocation(line: 66, column: 6, scope: !336)
!336 = distinct !DILexicalBlock(scope: !160, file: !22, line: 66, column: 5)
!337 = !DILocation(line: 66, column: 5, scope: !160)
!338 = !DILocation(line: 68, column: 25, scope: !339)
!339 = distinct !DILexicalBlock(scope: !336, file: !22, line: 67, column: 1)
!340 = !DILocation(line: 68, column: 15, scope: !339)
!341 = !DILocation(line: 69, column: 3, scope: !339)
!342 = !DILocation(line: 71, column: 13, scope: !160)
!343 = !DILocation(line: 73, column: 43, scope: !160)
!344 = !DILocation(line: 74, column: 6, scope: !345)
!345 = distinct !DILexicalBlock(scope: !160, file: !22, line: 74, column: 5)
!346 = !DILocation(line: 74, column: 5, scope: !160)
!347 = !DILocation(line: 76, column: 25, scope: !348)
!348 = distinct !DILexicalBlock(scope: !345, file: !22, line: 75, column: 1)
!349 = !DILocation(line: 76, column: 15, scope: !348)
!350 = !DILocation(line: 77, column: 3, scope: !348)
!351 = !DILocation(line: 80, column: 30, scope: !160)
!352 = !DILocation(line: 81, column: 6, scope: !353)
!353 = distinct !DILexicalBlock(scope: !160, file: !22, line: 81, column: 5)
!354 = !DILocation(line: 81, column: 5, scope: !160)
!355 = !DILocation(line: 83, column: 25, scope: !356)
!356 = distinct !DILexicalBlock(scope: !353, file: !22, line: 82, column: 1)
!357 = !DILocation(line: 83, column: 15, scope: !356)
!358 = !DILocation(line: 84, column: 3, scope: !356)
!359 = !DILocation(line: 86, column: 19, scope: !160)
!360 = !DILocation(line: 93, column: 11, scope: !160)
!361 = !DILocation(line: 96, column: 1, scope: !160)
!362 = !DILocation(line: 107, column: 15, scope: !363)
!363 = distinct !DILexicalBlock(scope: !364, file: !22, line: 106, column: 25)
!364 = distinct !DILexicalBlock(scope: !160, file: !22, line: 106, column: 4)
!365 = !DILocation(line: 135, column: 1, scope: !160)
!366 = !DILocation(line: 142, column: 15, scope: !367)
!367 = distinct !DILexicalBlock(scope: !368, file: !22, line: 141, column: 56)
!368 = distinct !DILexicalBlock(scope: !255, file: !22, line: 141, column: 4)
!369 = !DILocation(line: 146, column: 1, scope: !255)
!370 = !DILocation(line: 157, column: 1, scope: !259)
!371 = !DILocation(line: 168, column: 1, scope: !263)
!372 = !DILocation(line: 175, column: 1, scope: !267)
!373 = !DILocation(line: 0, scope: !265)
!374 = !DILocalVariable(name: "result", arg: 1, scope: !375, file: !135, line: 103, type: !378)
!375 = distinct !DISubprogram(name: "Sum", scope: !135, file: !135, line: 103, type: !376, scopeLine: 104, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !380)
!376 = !DISubroutineType(types: !377)
!377 = !{null, !378, !379, !379}
!378 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !190, size: 64)
!379 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !194, size: 64)
!380 = !{!374, !381, !382}
!381 = !DILocalVariable(name: "var1", arg: 2, scope: !375, file: !135, line: 103, type: !379)
!382 = !DILocalVariable(name: "var2", arg: 3, scope: !375, file: !135, line: 103, type: !379)
!383 = !DILocation(line: 0, scope: !375, inlinedAt: !384)
!384 = distinct !DILocation(line: 180, column: 1, scope: !265)
!385 = !DILocation(line: 201, column: 1, scope: !160)
!386 = !DILocation(line: 208, column: 1, scope: !271)
!387 = !DILocation(line: 208, column: 1, scope: !160)
!388 = !DILocation(line: 218, column: 1, scope: !160)
!389 = !DILocation(line: 220, column: 1, scope: !160)
!390 = !DILocation(line: 221, column: 3, scope: !277)
!391 = !DILocation(line: 221, column: 3, scope: !160)
!392 = !DILocation(line: 222, column: 3, scope: !160)
!393 = !DILocation(line: 224, column: 1, scope: !160)
