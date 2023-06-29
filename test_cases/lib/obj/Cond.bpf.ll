; ModuleID = '/home/vinicius/honey-potion/test_cases/lib/src/Cond.bpf.c'
source_filename = "/home/vinicius/honey-potion/test_cases/lib/src/Cond.bpf.c"
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
@__const.main_func.____fmt.9 = private unnamed_addr constant [7 x i8] c"Is 32.\00", align 1
@__const.main_func.____fmt.11 = private unnamed_addr constant [7 x i8] c"** %s\0A\00", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @LICENSE, ptr @heap_index_map, ptr @heap_map, ptr @main_func, ptr @string_pool_index_map, ptr @string_pool_map, ptr @tuple_pool_index_map, ptr @tuple_pool_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(ptr nocapture readnone %0) #0 section "tracepoint/raw_syscalls/sys_enter" !dbg !150 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr undef, metadata !169, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.declare(metadata ptr undef, metadata !177, metadata !DIExpression()), !dbg !280
  call void @llvm.dbg.declare(metadata ptr undef, metadata !178, metadata !DIExpression()), !dbg !281
  %6 = alloca %struct.OpResult, align 8
  %7 = alloca i32, align 4
  %8 = alloca [7 x i8], align 1
  %9 = alloca [7 x i8], align 1
  call void @llvm.dbg.value(metadata ptr poison, metadata !168, metadata !DIExpression()), !dbg !282
  call void @llvm.lifetime.start.p0(i64 184, ptr nonnull %6) #6, !dbg !283
  call void @llvm.dbg.declare(metadata ptr %6, metadata !179, metadata !DIExpression()), !dbg !284
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(184) %6, i8 0, i64 184, i1 false), !dbg !284
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %7) #6, !dbg !285
  call void @llvm.dbg.value(metadata i32 0, metadata !219, metadata !DIExpression()), !dbg !282
  store i32 0, ptr %7, align 4, !dbg !286, !tbaa !287
  call void @llvm.dbg.value(metadata ptr %7, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %10 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %7) #6, !dbg !291
  call void @llvm.dbg.value(metadata ptr %10, metadata !220, metadata !DIExpression()), !dbg !282
  %11 = icmp eq ptr %10, null, !dbg !292
  br i1 %11, label %12, label %15, !dbg !294

12:                                               ; preds = %1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !dbg !295
  %13 = getelementptr inbounds i8, ptr %6, i64 24, !dbg !297
  store i32 1, ptr %13, align 8, !dbg !297, !tbaa.struct !298
  %14 = getelementptr inbounds i8, ptr %6, i64 28, !dbg !297
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %14, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !297, !tbaa.struct !300
  br label %56, !dbg !301

15:                                               ; preds = %1
  call void @llvm.dbg.value(metadata ptr %7, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %16 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_index_map, ptr noundef nonnull %7) #6, !dbg !302
  call void @llvm.dbg.value(metadata ptr %16, metadata !223, metadata !DIExpression()), !dbg !282
  %17 = icmp eq ptr %16, null, !dbg !303
  br i1 %17, label %18, label %21, !dbg !305

18:                                               ; preds = %15
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !dbg !306
  %19 = getelementptr inbounds i8, ptr %6, i64 24, !dbg !308
  store i32 1, ptr %19, align 8, !dbg !308, !tbaa.struct !298
  %20 = getelementptr inbounds i8, ptr %6, i64 28, !dbg !308
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %20, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !308, !tbaa.struct !300
  br label %56, !dbg !309

21:                                               ; preds = %15
  store i32 0, ptr %16, align 4, !dbg !310, !tbaa !287
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %10, ptr noundef nonnull align 1 dereferenceable(3) @.str.2, i64 3, i1 false), !dbg !311
  %22 = getelementptr inbounds i8, ptr %10, i64 3, !dbg !312
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %22, ptr noundef nonnull align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !dbg !313
  %23 = getelementptr inbounds i8, ptr %10, i64 8, !dbg !314
  store i32 1702195828, ptr %23, align 1, !dbg !315
  call void @llvm.dbg.value(metadata ptr %7, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %24 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_map, ptr noundef nonnull %7) #6, !dbg !316
  call void @llvm.dbg.value(metadata ptr %24, metadata !225, metadata !DIExpression()), !dbg !282
  %25 = icmp eq ptr %24, null, !dbg !317
  br i1 %25, label %26, label %29, !dbg !319

26:                                               ; preds = %21
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !dbg !320
  %27 = getelementptr inbounds i8, ptr %6, i64 24, !dbg !322
  store i32 1, ptr %27, align 8, !dbg !322, !tbaa.struct !298
  %28 = getelementptr inbounds i8, ptr %6, i64 28, !dbg !322
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %28, ptr noundef nonnull align 4 dereferenceable(150) @.str.5, i64 150, i1 false), !dbg !322, !tbaa.struct !300
  br label %56, !dbg !323

29:                                               ; preds = %21
  call void @llvm.dbg.value(metadata ptr %7, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %30 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_index_map, ptr noundef nonnull %7) #6, !dbg !324
  call void @llvm.dbg.value(metadata ptr %30, metadata !230, metadata !DIExpression()), !dbg !282
  %31 = icmp eq ptr %30, null, !dbg !325
  br i1 %31, label %32, label %35, !dbg !327

32:                                               ; preds = %29
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !dbg !328
  %33 = getelementptr inbounds i8, ptr %6, i64 24, !dbg !330
  store i32 1, ptr %33, align 8, !dbg !330, !tbaa.struct !298
  %34 = getelementptr inbounds i8, ptr %6, i64 28, !dbg !330
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %34, ptr noundef nonnull align 4 dereferenceable(150) @.str.6, i64 150, i1 false), !dbg !330, !tbaa.struct !300
  br label %56, !dbg !331

35:                                               ; preds = %29
  store i32 0, ptr %30, align 4, !dbg !332, !tbaa !287
  call void @llvm.dbg.value(metadata ptr %7, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %36 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_map, ptr noundef nonnull %7) #6, !dbg !333
  call void @llvm.dbg.value(metadata ptr %36, metadata !231, metadata !DIExpression()), !dbg !282
  %37 = icmp eq ptr %36, null, !dbg !334
  br i1 %37, label %38, label %41, !dbg !336

38:                                               ; preds = %35
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !dbg !337
  %39 = getelementptr inbounds i8, ptr %6, i64 24, !dbg !339
  store i32 1, ptr %39, align 8, !dbg !339, !tbaa.struct !298
  %40 = getelementptr inbounds i8, ptr %6, i64 28, !dbg !339
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %40, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !339, !tbaa.struct !300
  br label %56, !dbg !340

41:                                               ; preds = %35
  call void @llvm.dbg.value(metadata ptr %7, metadata !219, metadata !DIExpression(DW_OP_deref)), !dbg !282
  %42 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_index_map, ptr noundef nonnull %7) #6, !dbg !341
  call void @llvm.dbg.value(metadata ptr %42, metadata !234, metadata !DIExpression()), !dbg !282
  %43 = icmp eq ptr %42, null, !dbg !342
  br i1 %43, label %44, label %47, !dbg !344

44:                                               ; preds = %41
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %6, i8 0, i64 24, i1 false), !dbg !345
  %45 = getelementptr inbounds i8, ptr %6, i64 24, !dbg !347
  store i32 1, ptr %45, align 8, !dbg !347, !tbaa.struct !298
  %46 = getelementptr inbounds i8, ptr %6, i64 28, !dbg !347
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %46, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !347, !tbaa.struct !300
  br label %56, !dbg !348

47:                                               ; preds = %41
  store i32 0, ptr %42, align 4, !dbg !349, !tbaa !287
  %48 = getelementptr inbounds %struct.OpResult, ptr %6, i64 0, i32 1, !dbg !350
  call void @llvm.dbg.value(metadata i32 2, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 undef, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i64 32, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !282
  call void @llvm.dbg.value(metadata i64 undef, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  call void @llvm.dbg.label(metadata !277), !dbg !351
  call void @llvm.dbg.value(metadata i32 2, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 undef, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i64 undef, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  call void @llvm.dbg.value(metadata i32 2, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 undef, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i64 23, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !282
  call void @llvm.dbg.value(metadata i64 undef, metadata !238, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  call void @llvm.dbg.value(metadata ptr %6, metadata !352, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.value(metadata ptr undef, metadata !359, metadata !DIExpression()), !dbg !361
  call void @llvm.dbg.value(metadata ptr undef, metadata !360, metadata !DIExpression()), !dbg !361
  %49 = getelementptr inbounds i8, ptr %6, i64 8, !dbg !363
  %50 = getelementptr inbounds i8, ptr %6, i64 12, !dbg !367
  call void @llvm.dbg.value(metadata i32 0, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i64 0, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  call void @llvm.dbg.value(metadata i32 5, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 3, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 undef, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i64 undef, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  call void @llvm.dbg.value(metadata ptr undef, metadata !369, metadata !DIExpression()), !dbg !380
  call void @llvm.dbg.value(metadata i32 7, metadata !239, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !282
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %5) #6, !dbg !382
  call void @llvm.dbg.value(metadata i32 0, metadata !374, metadata !DIExpression()), !dbg !383
  store i32 0, ptr %5, align 4, !dbg !384, !tbaa !287
  call void @llvm.dbg.value(metadata i32 3, metadata !377, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata i32 undef, metadata !378, metadata !DIExpression()), !dbg !383
  call void @llvm.dbg.value(metadata ptr %5, metadata !374, metadata !DIExpression(DW_OP_deref)), !dbg !383
  %51 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %5) #6, !dbg !385
  call void @llvm.dbg.value(metadata ptr %51, metadata !379, metadata !DIExpression()), !dbg !383
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %5) #6, !dbg !386
  call void @llvm.dbg.value(metadata i32 2, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i32 undef, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i64 23445, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !387
  call void @llvm.dbg.value(metadata i64 undef, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !387
  call void @llvm.dbg.value(metadata ptr %6, metadata !352, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.value(metadata ptr undef, metadata !359, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.value(metadata ptr undef, metadata !360, metadata !DIExpression()), !dbg !388
  call void @llvm.dbg.value(metadata i32 0, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i32 0, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i32 0, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i64 0, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !387
  call void @llvm.dbg.value(metadata i32 5, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i32 3, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i32 7, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !387
  call void @llvm.dbg.value(metadata i64 undef, metadata !250, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !387
  call void @llvm.dbg.value(metadata ptr undef, metadata !369, metadata !DIExpression()), !dbg !390
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %4) #6, !dbg !392
  call void @llvm.dbg.value(metadata i32 0, metadata !374, metadata !DIExpression()), !dbg !393
  store i32 0, ptr %4, align 4, !dbg !394, !tbaa !287
  call void @llvm.dbg.value(metadata i32 3, metadata !377, metadata !DIExpression()), !dbg !393
  call void @llvm.dbg.value(metadata i32 7, metadata !378, metadata !DIExpression()), !dbg !393
  call void @llvm.dbg.value(metadata ptr %4, metadata !374, metadata !DIExpression(DW_OP_deref)), !dbg !393
  %52 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %4) #6, !dbg !395
  call void @llvm.dbg.value(metadata ptr %52, metadata !379, metadata !DIExpression()), !dbg !393
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %4) #6, !dbg !396
  call void @llvm.dbg.value(metadata i32 2, metadata !259, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i32 undef, metadata !259, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i64 51234, metadata !259, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !397
  call void @llvm.dbg.value(metadata i64 undef, metadata !259, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !397
  call void @llvm.dbg.value(metadata ptr %6, metadata !352, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.value(metadata ptr undef, metadata !359, metadata !DIExpression()), !dbg !398
  call void @llvm.dbg.value(metadata ptr undef, metadata !360, metadata !DIExpression()), !dbg !398
  store i32 0, ptr %48, align 8, !dbg !400, !tbaa !401
  store i32 5, ptr %6, align 8, !dbg !404
  store i32 3, ptr %49, align 8, !dbg !405, !tbaa.struct !406
  store i32 7, ptr %50, align 4, !dbg !405, !tbaa.struct !411
  call void @llvm.dbg.value(metadata i32 0, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i32 0, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i32 0, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i64 0, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !397
  call void @llvm.dbg.value(metadata i32 5, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i32 3, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i32 7, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !397
  call void @llvm.dbg.value(metadata i64 undef, metadata !261, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !397
  call void @llvm.dbg.value(metadata ptr undef, metadata !369, metadata !DIExpression()), !dbg !412
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6, !dbg !414
  call void @llvm.dbg.value(metadata i32 0, metadata !374, metadata !DIExpression()), !dbg !415
  store i32 0, ptr %3, align 4, !dbg !416, !tbaa !287
  call void @llvm.dbg.value(metadata i32 3, metadata !377, metadata !DIExpression()), !dbg !415
  call void @llvm.dbg.value(metadata i32 7, metadata !378, metadata !DIExpression()), !dbg !415
  call void @llvm.dbg.value(metadata ptr %3, metadata !374, metadata !DIExpression(DW_OP_deref)), !dbg !415
  %53 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %3) #6, !dbg !417
  call void @llvm.dbg.value(metadata ptr %53, metadata !379, metadata !DIExpression()), !dbg !415
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6, !dbg !418
  call void @llvm.dbg.value(metadata i32 2, metadata !267, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i32 undef, metadata !267, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i64 32, metadata !267, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !419
  call void @llvm.dbg.value(metadata i64 undef, metadata !267, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !419
  call void @llvm.dbg.value(metadata ptr %6, metadata !352, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.value(metadata ptr undef, metadata !359, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.value(metadata ptr undef, metadata !360, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.value(metadata i32 0, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i32 0, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i32 0, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i64 0, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !419
  call void @llvm.dbg.value(metadata i32 5, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i32 undef, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i32 11, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !419
  call void @llvm.dbg.value(metadata i64 undef, metadata !269, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !419
  call void @llvm.dbg.value(metadata ptr undef, metadata !369, metadata !DIExpression()), !dbg !422
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #6, !dbg !424
  call void @llvm.dbg.value(metadata i32 0, metadata !374, metadata !DIExpression()), !dbg !425
  store i32 0, ptr %2, align 4, !dbg !426, !tbaa !287
  call void @llvm.dbg.value(metadata i32 undef, metadata !377, metadata !DIExpression()), !dbg !425
  call void @llvm.dbg.value(metadata i32 11, metadata !378, metadata !DIExpression()), !dbg !425
  call void @llvm.dbg.value(metadata ptr %2, metadata !374, metadata !DIExpression(DW_OP_deref)), !dbg !425
  %54 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %2) #6, !dbg !427
  call void @llvm.dbg.value(metadata ptr %54, metadata !379, metadata !DIExpression()), !dbg !425
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #6, !dbg !428
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %8) #6, !dbg !429
  call void @llvm.dbg.declare(metadata ptr %8, metadata !270, metadata !DIExpression()), !dbg !429
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %8, ptr noundef nonnull align 1 dereferenceable(7) @__const.main_func.____fmt.9, i64 7, i1 false), !dbg !429
  %55 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %8, i32 noundef 7) #6, !dbg !429
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %8) #6, !dbg !430
  call void @llvm.dbg.value(metadata i32 2, metadata !274, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !431
  call void @llvm.dbg.value(metadata i32 undef, metadata !274, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !431
  call void @llvm.dbg.value(metadata i64 0, metadata !274, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !431
  call void @llvm.dbg.value(metadata i64 undef, metadata !274, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !431
  call void @llvm.dbg.value(metadata i32 2, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 undef, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i32 0, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !282
  call void @llvm.dbg.value(metadata i64 undef, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !282
  br label %59, !dbg !432

56:                                               ; preds = %44, %38, %32, %26, %18, %12
  call void @llvm.dbg.label(metadata !278), !dbg !433
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %9) #6, !dbg !434
  call void @llvm.dbg.declare(metadata ptr %9, metadata !275, metadata !DIExpression()), !dbg !434
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %9, ptr noundef nonnull align 1 dereferenceable(7) @__const.main_func.____fmt.11, i64 7, i1 false), !dbg !434
  %57 = getelementptr inbounds %struct.OpResult, ptr %6, i64 0, i32 2, !dbg !434
  %58 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %9, i32 noundef 7, ptr noundef nonnull %57) #6, !dbg !434
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %9) #6, !dbg !435
  br label %59, !dbg !436

59:                                               ; preds = %47, %56
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %7) #6, !dbg !437
  call void @llvm.lifetime.end.p0(i64 184, ptr nonnull %6) #6, !dbg !437
  ret i32 0, !dbg !437
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
!llvm.module.flags = !{!145, !146, !147, !148}
!llvm.ident = !{!149}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !22, line: 25, type: !142, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/vinicius/honey-potion/test_cases/lib/src/Cond.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "565c351f3e6a2327e0e9e05ec743d7ed")
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
!19 = !{!0, !20, !27, !29, !34, !39, !44, !46, !48, !50, !72, !80, !92, !100, !112, !120, !129, !132}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !22, line: 42, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "src/Cond.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "565c351f3e6a2327e0e9e05ec743d7ed")
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
!49 = distinct !DIGlobalVariable(scope: null, file: !22, line: 173, type: !23, isLocal: true, isDefinition: true)
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
!130 = distinct !DIGlobalVariable(scope: null, file: !131, line: 303, type: !23, isLocal: true, isDefinition: true)
!131 = !DIFile(filename: "_build/dev/lib/honey/priv/c_boilerplates/runtime_functions.bpf.c", directory: "/home/vinicius/honey-potion/test_cases", checksumkind: CSK_MD5, checksum: "b230f5be759074326648f496f90fd18a")
!132 = !DIGlobalVariableExpression(var: !133, expr: !DIExpression())
!133 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !122, line: 171, type: !134, isLocal: true, isDefinition: true)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = !DISubroutineType(types: !136)
!136 = !{!137, !138, !140, null}
!137 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!139 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !141, line: 27, baseType: !7)
!141 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!142 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 104, elements: !143)
!143 = !{!144}
!144 = !DISubrange(count: 13)
!145 = !{i32 7, !"Dwarf Version", i32 5}
!146 = !{i32 2, !"Debug Info Version", i32 3}
!147 = !{i32 1, !"wchar_size", i32 4}
!148 = !{i32 7, !"frame-pointer", i32 2}
!149 = !{!"Homebrew clang version 15.0.7"}
!150 = distinct !DISubprogram(name: "main_func", scope: !22, file: !22, line: 30, type: !151, scopeLine: 30, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !167)
!151 = !DISubroutineType(types: !152)
!152 = !{!58, !153}
!153 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!154 = !DIDerivedType(tag: DW_TAG_typedef, name: "syscalls_enter_args", file: !22, line: 23, baseType: !155)
!155 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_args", file: !22, line: 11, size: 512, elements: !156)
!156 = !{!157, !159, !161, !162, !163, !164}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "common_type", scope: !155, file: !22, line: 17, baseType: !158, size: 16)
!158 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "common_flags", scope: !155, file: !22, line: 18, baseType: !160, size: 8, offset: 16)
!160 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "common_preempt_count", scope: !155, file: !22, line: 19, baseType: !160, size: 8, offset: 24)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "common_pid", scope: !155, file: !22, line: 20, baseType: !58, size: 32, offset: 32)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !155, file: !22, line: 21, baseType: !137, size: 64, offset: 64)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !155, file: !22, line: 22, baseType: !165, size: 384, offset: 128)
!165 = !DICompositeType(tag: DW_TAG_array_type, baseType: !166, size: 384, elements: !37)
!166 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!167 = !{!168, !169, !177, !178, !179, !219, !220, !223, !225, !230, !231, !234, !235, !236, !237, !238, !239, !240, !247, !248, !250, !251, !258, !259, !261, !262, !266, !267, !269, !270, !274, !275, !277, !278}
!168 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !150, file: !22, line: 30, type: !153)
!169 = !DILocalVariable(name: "str_param1", scope: !150, file: !22, line: 32, type: !170)
!170 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 105, baseType: !171)
!171 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 102, size: 16, elements: !172)
!172 = !{!173}
!173 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !171, file: !6, line: 104, baseType: !174, size: 16)
!174 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16, elements: !175)
!175 = !{!176}
!176 = !DISubrange(count: 2)
!177 = !DILocalVariable(name: "str_param2", scope: !150, file: !22, line: 33, type: !170)
!178 = !DILocalVariable(name: "str_param3", scope: !150, file: !22, line: 34, type: !170)
!179 = !DILocalVariable(name: "op_result", scope: !150, file: !22, line: 36, type: !180)
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
!193 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !191, file: !6, line: 81, baseType: !137, size: 64)
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
!219 = !DILocalVariable(name: "zero", scope: !150, file: !22, line: 38, type: !58)
!220 = !DILocalVariable(name: "string_pool", scope: !150, file: !22, line: 39, type: !221)
!221 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !222, size: 64)
!222 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 4000, elements: !70)
!223 = !DILocalVariable(name: "string_pool_index", scope: !150, file: !22, line: 46, type: !224)
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!225 = !DILocalVariable(name: "heap", scope: !150, file: !22, line: 58, type: !226)
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !227, size: 64)
!227 = !DICompositeType(tag: DW_TAG_array_type, baseType: !184, size: 19200, elements: !228)
!228 = !{!229}
!229 = !DISubrange(count: 100)
!230 = !DILocalVariable(name: "heap_index", scope: !150, file: !22, line: 65, type: !224)
!231 = !DILocalVariable(name: "tuple_pool", scope: !150, file: !22, line: 73, type: !232)
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !233, size: 64)
!233 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 16000, elements: !70)
!234 = !DILocalVariable(name: "tuple_pool_index", scope: !150, file: !22, line: 80, type: !224)
!235 = !DILocalVariable(name: "helper_var_196", scope: !150, file: !22, line: 92, type: !184)
!236 = !DILocalVariable(name: "x_0_", scope: !150, file: !22, line: 94, type: !184)
!237 = !DILocalVariable(name: "helper_var_260", scope: !150, file: !22, line: 102, type: !184)
!238 = !DILocalVariable(name: "helper_var_324", scope: !150, file: !22, line: 106, type: !184)
!239 = !DILocalVariable(name: "helper_var_388", scope: !150, file: !22, line: 107, type: !184)
!240 = !DILocalVariable(name: "____fmt", scope: !241, file: !22, line: 112, type: !244)
!241 = distinct !DILexicalBlock(scope: !242, file: !22, line: 112, column: 1)
!242 = distinct !DILexicalBlock(scope: !243, file: !22, line: 109, column: 31)
!243 = distinct !DILexicalBlock(scope: !150, file: !22, line: 109, column: 5)
!244 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 56, elements: !245)
!245 = !{!246}
!246 = !DISubrange(count: 7)
!247 = !DILocalVariable(name: "helper_var_452", scope: !242, file: !22, line: 113, type: !184)
!248 = !DILocalVariable(name: "helper_var_516", scope: !249, file: !22, line: 120, type: !184)
!249 = distinct !DILexicalBlock(scope: !243, file: !22, line: 116, column: 8)
!250 = !DILocalVariable(name: "helper_var_580", scope: !249, file: !22, line: 121, type: !184)
!251 = !DILocalVariable(name: "____fmt", scope: !252, file: !22, line: 126, type: !255)
!252 = distinct !DILexicalBlock(scope: !253, file: !22, line: 126, column: 1)
!253 = distinct !DILexicalBlock(scope: !254, file: !22, line: 123, column: 31)
!254 = distinct !DILexicalBlock(scope: !249, file: !22, line: 123, column: 5)
!255 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 80, elements: !256)
!256 = !{!257}
!257 = !DISubrange(count: 10)
!258 = !DILocalVariable(name: "helper_var_644", scope: !253, file: !22, line: 127, type: !184)
!259 = !DILocalVariable(name: "helper_var_708", scope: !260, file: !22, line: 134, type: !184)
!260 = distinct !DILexicalBlock(scope: !254, file: !22, line: 130, column: 8)
!261 = !DILocalVariable(name: "helper_var_772", scope: !260, file: !22, line: 135, type: !184)
!262 = !DILocalVariable(name: "____fmt", scope: !263, file: !22, line: 140, type: !255)
!263 = distinct !DILexicalBlock(scope: !264, file: !22, line: 140, column: 1)
!264 = distinct !DILexicalBlock(scope: !265, file: !22, line: 137, column: 31)
!265 = distinct !DILexicalBlock(scope: !260, file: !22, line: 137, column: 5)
!266 = !DILocalVariable(name: "helper_var_836", scope: !264, file: !22, line: 141, type: !184)
!267 = !DILocalVariable(name: "helper_var_900", scope: !268, file: !22, line: 148, type: !184)
!268 = distinct !DILexicalBlock(scope: !265, file: !22, line: 144, column: 8)
!269 = !DILocalVariable(name: "helper_var_964", scope: !268, file: !22, line: 149, type: !184)
!270 = !DILocalVariable(name: "____fmt", scope: !271, file: !22, line: 154, type: !244)
!271 = distinct !DILexicalBlock(scope: !272, file: !22, line: 154, column: 1)
!272 = distinct !DILexicalBlock(scope: !273, file: !22, line: 151, column: 31)
!273 = distinct !DILexicalBlock(scope: !268, file: !22, line: 151, column: 5)
!274 = !DILocalVariable(name: "helper_var_1028", scope: !272, file: !22, line: 155, type: !184)
!275 = !DILocalVariable(name: "____fmt", scope: !276, file: !22, line: 179, type: !244)
!276 = distinct !DILexicalBlock(scope: !150, file: !22, line: 179, column: 3)
!277 = !DILabel(scope: !150, name: "label_132", file: !22, line: 96)
!278 = !DILabel(scope: !150, name: "CATCH", file: !22, line: 178)
!279 = !DILocation(line: 32, column: 15, scope: !150)
!280 = !DILocation(line: 33, column: 15, scope: !150)
!281 = !DILocation(line: 34, column: 15, scope: !150)
!282 = !DILocation(line: 0, scope: !150)
!283 = !DILocation(line: 36, column: 1, scope: !150)
!284 = !DILocation(line: 36, column: 10, scope: !150)
!285 = !DILocation(line: 38, column: 1, scope: !150)
!286 = !DILocation(line: 38, column: 5, scope: !150)
!287 = !{!288, !288, i64 0}
!288 = !{!"int", !289, i64 0}
!289 = !{!"omnipotent char", !290, i64 0}
!290 = !{!"Simple C/C++ TBAA"}
!291 = !DILocation(line: 39, column: 40, scope: !150)
!292 = !DILocation(line: 40, column: 6, scope: !293)
!293 = distinct !DILexicalBlock(scope: !150, file: !22, line: 40, column: 5)
!294 = !DILocation(line: 40, column: 5, scope: !150)
!295 = !DILocation(line: 42, column: 25, scope: !296)
!296 = distinct !DILexicalBlock(scope: !293, file: !22, line: 41, column: 1)
!297 = !DILocation(line: 42, column: 15, scope: !296)
!298 = !{i64 0, i64 4, !287, i64 4, i64 150, !299}
!299 = !{!289, !289, i64 0}
!300 = !{i64 0, i64 150, !299}
!301 = !DILocation(line: 43, column: 3, scope: !296)
!302 = !DILocation(line: 46, column: 31, scope: !150)
!303 = !DILocation(line: 47, column: 6, scope: !304)
!304 = distinct !DILexicalBlock(scope: !150, file: !22, line: 47, column: 5)
!305 = !DILocation(line: 47, column: 5, scope: !150)
!306 = !DILocation(line: 49, column: 25, scope: !307)
!307 = distinct !DILexicalBlock(scope: !304, file: !22, line: 48, column: 1)
!308 = !DILocation(line: 49, column: 15, scope: !307)
!309 = !DILocation(line: 50, column: 3, scope: !307)
!310 = !DILocation(line: 52, column: 20, scope: !150)
!311 = !DILocation(line: 54, column: 1, scope: !150)
!312 = !DILocation(line: 55, column: 31, scope: !150)
!313 = !DILocation(line: 55, column: 1, scope: !150)
!314 = !DILocation(line: 56, column: 35, scope: !150)
!315 = !DILocation(line: 56, column: 1, scope: !150)
!316 = !DILocation(line: 58, column: 29, scope: !150)
!317 = !DILocation(line: 59, column: 6, scope: !318)
!318 = distinct !DILexicalBlock(scope: !150, file: !22, line: 59, column: 5)
!319 = !DILocation(line: 59, column: 5, scope: !150)
!320 = !DILocation(line: 61, column: 25, scope: !321)
!321 = distinct !DILexicalBlock(scope: !318, file: !22, line: 60, column: 1)
!322 = !DILocation(line: 61, column: 15, scope: !321)
!323 = !DILocation(line: 62, column: 3, scope: !321)
!324 = !DILocation(line: 65, column: 24, scope: !150)
!325 = !DILocation(line: 66, column: 6, scope: !326)
!326 = distinct !DILexicalBlock(scope: !150, file: !22, line: 66, column: 5)
!327 = !DILocation(line: 66, column: 5, scope: !150)
!328 = !DILocation(line: 68, column: 25, scope: !329)
!329 = distinct !DILexicalBlock(scope: !326, file: !22, line: 67, column: 1)
!330 = !DILocation(line: 68, column: 15, scope: !329)
!331 = !DILocation(line: 69, column: 3, scope: !329)
!332 = !DILocation(line: 71, column: 13, scope: !150)
!333 = !DILocation(line: 73, column: 43, scope: !150)
!334 = !DILocation(line: 74, column: 6, scope: !335)
!335 = distinct !DILexicalBlock(scope: !150, file: !22, line: 74, column: 5)
!336 = !DILocation(line: 74, column: 5, scope: !150)
!337 = !DILocation(line: 76, column: 25, scope: !338)
!338 = distinct !DILexicalBlock(scope: !335, file: !22, line: 75, column: 1)
!339 = !DILocation(line: 76, column: 15, scope: !338)
!340 = !DILocation(line: 77, column: 3, scope: !338)
!341 = !DILocation(line: 80, column: 30, scope: !150)
!342 = !DILocation(line: 81, column: 6, scope: !343)
!343 = distinct !DILexicalBlock(scope: !150, file: !22, line: 81, column: 5)
!344 = !DILocation(line: 81, column: 5, scope: !150)
!345 = !DILocation(line: 83, column: 25, scope: !346)
!346 = distinct !DILexicalBlock(scope: !343, file: !22, line: 82, column: 1)
!347 = !DILocation(line: 83, column: 15, scope: !346)
!348 = !DILocation(line: 84, column: 3, scope: !346)
!349 = !DILocation(line: 86, column: 19, scope: !150)
!350 = !DILocation(line: 93, column: 11, scope: !150)
!351 = !DILocation(line: 96, column: 1, scope: !150)
!352 = !DILocalVariable(name: "result", arg: 1, scope: !353, file: !131, line: 282, type: !356)
!353 = distinct !DISubprogram(name: "Equals", scope: !131, file: !131, line: 282, type: !354, scopeLine: 282, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !358)
!354 = !DISubroutineType(types: !355)
!355 = !{null, !356, !357, !357}
!356 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!357 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !184, size: 64)
!358 = !{!352, !359, !360}
!359 = !DILocalVariable(name: "var1", arg: 2, scope: !353, file: !131, line: 282, type: !357)
!360 = !DILocalVariable(name: "var2", arg: 3, scope: !353, file: !131, line: 282, type: !357)
!361 = !DILocation(line: 0, scope: !353, inlinedAt: !362)
!362 = distinct !DILocation(line: 107, column: 1, scope: !150)
!363 = !DILocation(line: 0, scope: !364, inlinedAt: !362)
!364 = distinct !DILexicalBlock(scope: !365, file: !131, line: 291, column: 8)
!365 = distinct !DILexicalBlock(scope: !366, file: !131, line: 290, column: 29)
!366 = distinct !DILexicalBlock(scope: !353, file: !131, line: 290, column: 6)
!367 = !DILocation(line: 294, column: 28, scope: !368, inlinedAt: !362)
!368 = distinct !DILexicalBlock(scope: !364, file: !131, line: 293, column: 12)
!369 = !DILocalVariable(name: "var", arg: 1, scope: !370, file: !131, line: 5, type: !357)
!370 = distinct !DISubprogram(name: "to_bool", scope: !131, file: !131, line: 5, type: !371, scopeLine: 6, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !373)
!371 = !DISubroutineType(types: !372)
!372 = !{!58, !357}
!373 = !{!369, !374, !377, !378, !379}
!374 = !DILocalVariable(name: "zero", scope: !375, file: !131, line: 9, type: !58)
!375 = distinct !DILexicalBlock(scope: !376, file: !131, line: 8, column: 3)
!376 = distinct !DILexicalBlock(scope: !370, file: !131, line: 7, column: 7)
!377 = !DILocalVariable(name: "start", scope: !375, file: !131, line: 10, type: !7)
!378 = !DILocalVariable(name: "end", scope: !375, file: !131, line: 11, type: !7)
!379 = !DILocalVariable(name: "string_pool", scope: !375, file: !131, line: 12, type: !221)
!380 = !DILocation(line: 0, scope: !370, inlinedAt: !381)
!381 = distinct !DILocation(line: 109, column: 5, scope: !243)
!382 = !DILocation(line: 9, column: 5, scope: !375, inlinedAt: !381)
!383 = !DILocation(line: 0, scope: !375, inlinedAt: !381)
!384 = !DILocation(line: 9, column: 9, scope: !375, inlinedAt: !381)
!385 = !DILocation(line: 12, column: 44, scope: !375, inlinedAt: !381)
!386 = !DILocation(line: 26, column: 3, scope: !376, inlinedAt: !381)
!387 = !DILocation(line: 0, scope: !249)
!388 = !DILocation(line: 0, scope: !353, inlinedAt: !389)
!389 = distinct !DILocation(line: 121, column: 1, scope: !249)
!390 = !DILocation(line: 0, scope: !370, inlinedAt: !391)
!391 = distinct !DILocation(line: 123, column: 5, scope: !254)
!392 = !DILocation(line: 9, column: 5, scope: !375, inlinedAt: !391)
!393 = !DILocation(line: 0, scope: !375, inlinedAt: !391)
!394 = !DILocation(line: 9, column: 9, scope: !375, inlinedAt: !391)
!395 = !DILocation(line: 12, column: 44, scope: !375, inlinedAt: !391)
!396 = !DILocation(line: 26, column: 3, scope: !376, inlinedAt: !391)
!397 = !DILocation(line: 0, scope: !260)
!398 = !DILocation(line: 0, scope: !353, inlinedAt: !399)
!399 = distinct !DILocation(line: 135, column: 1, scope: !260)
!400 = !DILocation(line: 283, column: 21, scope: !353, inlinedAt: !399)
!401 = !{!402, !288, i64 24}
!402 = !{!"OpResult", !403, i64 0, !288, i64 24, !289, i64 28}
!403 = !{!"Generic", !289, i64 0, !289, i64 8}
!404 = !DILocation(line: 0, scope: !364, inlinedAt: !399)
!405 = !DILocation(line: 294, column: 28, scope: !368, inlinedAt: !399)
!406 = !{i64 0, i64 8, !407, i64 0, i64 4, !287, i64 0, i64 8, !409, i64 0, i64 4, !287, i64 4, i64 4, !287, i64 0, i64 4, !287, i64 4, i64 4, !287, i64 0, i64 4, !287, i64 4, i64 4, !287, i64 8, i64 4, !287, i64 12, i64 4, !287}
!407 = !{!408, !408, i64 0}
!408 = !{!"long", !289, i64 0}
!409 = !{!410, !410, i64 0}
!410 = !{!"double", !289, i64 0}
!411 = !{i64 0, i64 4, !407, i64 0, i64 4, !409, i64 0, i64 4, !287, i64 0, i64 4, !287, i64 0, i64 4, !287, i64 4, i64 4, !287, i64 8, i64 4, !287}
!412 = !DILocation(line: 0, scope: !370, inlinedAt: !413)
!413 = distinct !DILocation(line: 137, column: 5, scope: !265)
!414 = !DILocation(line: 9, column: 5, scope: !375, inlinedAt: !413)
!415 = !DILocation(line: 0, scope: !375, inlinedAt: !413)
!416 = !DILocation(line: 9, column: 9, scope: !375, inlinedAt: !413)
!417 = !DILocation(line: 12, column: 44, scope: !375, inlinedAt: !413)
!418 = !DILocation(line: 26, column: 3, scope: !376, inlinedAt: !413)
!419 = !DILocation(line: 0, scope: !268)
!420 = !DILocation(line: 0, scope: !353, inlinedAt: !421)
!421 = distinct !DILocation(line: 149, column: 1, scope: !268)
!422 = !DILocation(line: 0, scope: !370, inlinedAt: !423)
!423 = distinct !DILocation(line: 151, column: 5, scope: !273)
!424 = !DILocation(line: 9, column: 5, scope: !375, inlinedAt: !423)
!425 = !DILocation(line: 0, scope: !375, inlinedAt: !423)
!426 = !DILocation(line: 9, column: 9, scope: !375, inlinedAt: !423)
!427 = !DILocation(line: 12, column: 44, scope: !375, inlinedAt: !423)
!428 = !DILocation(line: 26, column: 3, scope: !376, inlinedAt: !423)
!429 = !DILocation(line: 154, column: 1, scope: !271)
!430 = !DILocation(line: 154, column: 1, scope: !272)
!431 = !DILocation(line: 0, scope: !272)
!432 = !DILocation(line: 158, column: 1, scope: !272)
!433 = !DILocation(line: 178, column: 1, scope: !150)
!434 = !DILocation(line: 179, column: 3, scope: !276)
!435 = !DILocation(line: 179, column: 3, scope: !150)
!436 = !DILocation(line: 180, column: 3, scope: !150)
!437 = !DILocation(line: 182, column: 1, scope: !150)
