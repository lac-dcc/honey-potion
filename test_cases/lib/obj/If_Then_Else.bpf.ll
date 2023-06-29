; ModuleID = '/home/vinicius/honey-potion/test_cases/lib/src/If_Then_Else.bpf.c'
source_filename = "/home/vinicius/honey-potion/test_cases/lib/src/If_Then_Else.bpf.c"
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
@__const.main_func.____fmt.8 = private unnamed_addr constant [5 x i8] c"True\00", align 1
@__const.main_func.____fmt.11 = private unnamed_addr constant [7 x i8] c"** %s\0A\00", align 1
@llvm.compiler.used = appending global [8 x ptr] [ptr @LICENSE, ptr @heap_index_map, ptr @heap_map, ptr @main_func, ptr @string_pool_index_map, ptr @string_pool_map, ptr @tuple_pool_index_map, ptr @tuple_pool_map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(ptr nocapture readnone %0) #0 section "tracepoint/raw_syscalls/sys_enter" !dbg !151 {
  call void @llvm.dbg.declare(metadata ptr undef, metadata !170, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.declare(metadata ptr undef, metadata !178, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.declare(metadata ptr undef, metadata !179, metadata !DIExpression()), !dbg !259
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  %4 = alloca [5 x i8], align 1
  %5 = alloca [7 x i8], align 1
  call void @llvm.dbg.value(metadata ptr poison, metadata !169, metadata !DIExpression()), !dbg !260
  call void @llvm.lifetime.start.p0(i64 184, ptr nonnull %2) #6, !dbg !261
  call void @llvm.dbg.declare(metadata ptr %2, metadata !180, metadata !DIExpression()), !dbg !262
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(184) %2, i8 0, i64 184, i1 false), !dbg !262
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #6, !dbg !263
  call void @llvm.dbg.value(metadata i32 0, metadata !220, metadata !DIExpression()), !dbg !260
  store i32 0, ptr %3, align 4, !dbg !264, !tbaa !265
  call void @llvm.dbg.value(metadata ptr %3, metadata !220, metadata !DIExpression(DW_OP_deref)), !dbg !260
  %6 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %3) #6, !dbg !269
  call void @llvm.dbg.value(metadata ptr %6, metadata !221, metadata !DIExpression()), !dbg !260
  %7 = icmp eq ptr %6, null, !dbg !270
  br i1 %7, label %8, label %11, !dbg !272

8:                                                ; preds = %1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !273
  %9 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !275
  store i32 1, ptr %9, align 8, !dbg !275, !tbaa.struct !276
  %10 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !275
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %10, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !275, !tbaa.struct !278
  br label %45, !dbg !279

11:                                               ; preds = %1
  call void @llvm.dbg.value(metadata ptr %3, metadata !220, metadata !DIExpression(DW_OP_deref)), !dbg !260
  %12 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_index_map, ptr noundef nonnull %3) #6, !dbg !280
  call void @llvm.dbg.value(metadata ptr %12, metadata !224, metadata !DIExpression()), !dbg !260
  %13 = icmp eq ptr %12, null, !dbg !281
  br i1 %13, label %14, label %17, !dbg !283

14:                                               ; preds = %11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !284
  %15 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !286
  store i32 1, ptr %15, align 8, !dbg !286, !tbaa.struct !276
  %16 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !286
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %16, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !286, !tbaa.struct !278
  br label %45, !dbg !287

17:                                               ; preds = %11
  store i32 0, ptr %12, align 4, !dbg !288, !tbaa !265
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %6, ptr noundef nonnull align 1 dereferenceable(3) @.str.2, i64 3, i1 false), !dbg !289
  %18 = getelementptr inbounds i8, ptr %6, i64 3, !dbg !290
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %18, ptr noundef nonnull align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !dbg !291
  %19 = getelementptr inbounds i8, ptr %6, i64 8, !dbg !292
  store i32 1702195828, ptr %19, align 1, !dbg !293
  call void @llvm.dbg.value(metadata ptr %3, metadata !220, metadata !DIExpression(DW_OP_deref)), !dbg !260
  %20 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_map, ptr noundef nonnull %3) #6, !dbg !294
  call void @llvm.dbg.value(metadata ptr %20, metadata !226, metadata !DIExpression()), !dbg !260
  %21 = icmp eq ptr %20, null, !dbg !295
  br i1 %21, label %22, label %25, !dbg !297

22:                                               ; preds = %17
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !298
  %23 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !300
  store i32 1, ptr %23, align 8, !dbg !300, !tbaa.struct !276
  %24 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !300
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %24, ptr noundef nonnull align 4 dereferenceable(150) @.str.5, i64 150, i1 false), !dbg !300, !tbaa.struct !278
  br label %45, !dbg !301

25:                                               ; preds = %17
  call void @llvm.dbg.value(metadata ptr %3, metadata !220, metadata !DIExpression(DW_OP_deref)), !dbg !260
  %26 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_index_map, ptr noundef nonnull %3) #6, !dbg !302
  call void @llvm.dbg.value(metadata ptr %26, metadata !231, metadata !DIExpression()), !dbg !260
  %27 = icmp eq ptr %26, null, !dbg !303
  br i1 %27, label %28, label %31, !dbg !305

28:                                               ; preds = %25
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !306
  %29 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !308
  store i32 1, ptr %29, align 8, !dbg !308, !tbaa.struct !276
  %30 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !308
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %30, ptr noundef nonnull align 4 dereferenceable(150) @.str.6, i64 150, i1 false), !dbg !308, !tbaa.struct !278
  br label %45, !dbg !309

31:                                               ; preds = %25
  store i32 0, ptr %26, align 4, !dbg !310, !tbaa !265
  call void @llvm.dbg.value(metadata ptr %3, metadata !220, metadata !DIExpression(DW_OP_deref)), !dbg !260
  %32 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_map, ptr noundef nonnull %3) #6, !dbg !311
  call void @llvm.dbg.value(metadata ptr %32, metadata !232, metadata !DIExpression()), !dbg !260
  %33 = icmp eq ptr %32, null, !dbg !312
  br i1 %33, label %34, label %37, !dbg !314

34:                                               ; preds = %31
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !315
  %35 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !317
  store i32 1, ptr %35, align 8, !dbg !317, !tbaa.struct !276
  %36 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !317
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %36, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !317, !tbaa.struct !278
  br label %45, !dbg !318

37:                                               ; preds = %31
  call void @llvm.dbg.value(metadata ptr %3, metadata !220, metadata !DIExpression(DW_OP_deref)), !dbg !260
  %38 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_index_map, ptr noundef nonnull %3) #6, !dbg !319
  call void @llvm.dbg.value(metadata ptr %38, metadata !235, metadata !DIExpression()), !dbg !260
  %39 = icmp eq ptr %38, null, !dbg !320
  br i1 %39, label %40, label %43, !dbg !322

40:                                               ; preds = %37
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %2, i8 0, i64 24, i1 false), !dbg !323
  %41 = getelementptr inbounds i8, ptr %2, i64 24, !dbg !325
  store i32 1, ptr %41, align 8, !dbg !325, !tbaa.struct !276
  %42 = getelementptr inbounds i8, ptr %2, i64 28, !dbg !325
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %42, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !325, !tbaa.struct !278
  br label %45, !dbg !326

43:                                               ; preds = %37
  store i32 0, ptr %38, align 4, !dbg !327, !tbaa !265
  call void @llvm.dbg.value(metadata i32 5, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !260
  call void @llvm.dbg.value(metadata i32 undef, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !260
  call void @llvm.dbg.value(metadata i32 8, metadata !236, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !260
  call void @llvm.dbg.label(metadata !254), !dbg !328
  call void @llvm.dbg.label(metadata !255), !dbg !329
  call void @llvm.lifetime.start.p0(i64 5, ptr nonnull %4) #6, !dbg !330
  call void @llvm.dbg.declare(metadata ptr %4, metadata !243, metadata !DIExpression()), !dbg !330
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %4, ptr noundef nonnull align 1 dereferenceable(5) @__const.main_func.____fmt.8, i64 5, i1 false), !dbg !330
  %44 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %4, i32 noundef 5) #6, !dbg !330
  call void @llvm.lifetime.end.p0(i64 5, ptr nonnull %4) #6, !dbg !331
  call void @llvm.dbg.value(metadata i32 2, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !332
  call void @llvm.dbg.value(metadata i32 undef, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !332
  call void @llvm.dbg.value(metadata i64 0, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !332
  call void @llvm.dbg.value(metadata i64 undef, metadata !248, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !332
  call void @llvm.dbg.value(metadata i32 2, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !260
  call void @llvm.dbg.value(metadata i32 undef, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !260
  call void @llvm.dbg.value(metadata i64 0, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 64)), !dbg !260
  call void @llvm.dbg.value(metadata i64 undef, metadata !237, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 64)), !dbg !260
  br label %48

45:                                               ; preds = %40, %34, %28, %22, %14, %8
  call void @llvm.dbg.label(metadata !256), !dbg !333
  call void @llvm.lifetime.start.p0(i64 7, ptr nonnull %5) #6, !dbg !334
  call void @llvm.dbg.declare(metadata ptr %5, metadata !249, metadata !DIExpression()), !dbg !334
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(7) %5, ptr noundef nonnull align 1 dereferenceable(7) @__const.main_func.____fmt.11, i64 7, i1 false), !dbg !334
  %46 = getelementptr inbounds %struct.OpResult, ptr %2, i64 0, i32 2, !dbg !334
  %47 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull %5, i32 noundef 7, ptr noundef nonnull %46) #6, !dbg !334
  call void @llvm.lifetime.end.p0(i64 7, ptr nonnull %5) #6, !dbg !335
  br label %48, !dbg !336

48:                                               ; preds = %43, %45
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #6, !dbg !337
  call void @llvm.lifetime.end.p0(i64 184, ptr nonnull %2) #6, !dbg !337
  ret i32 0, !dbg !337
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
!llvm.module.flags = !{!146, !147, !148, !149}
!llvm.ident = !{!150}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !22, line: 25, type: !143, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Homebrew clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/vinicius/honey-potion/test_cases/lib/src/If_Then_Else.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "959d5596776591d53a72a23225100d11")
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
!19 = !{!0, !20, !27, !29, !34, !39, !44, !46, !48, !50, !52, !54, !76, !84, !96, !104, !116, !124, !133}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(scope: null, file: !22, line: 42, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "src/If_Then_Else.bpf.c", directory: "/home/vinicius/honey-potion/test_cases/lib", checksumkind: CSK_MD5, checksum: "959d5596776591d53a72a23225100d11")
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
!49 = distinct !DIGlobalVariable(scope: null, file: !22, line: 94, type: !23, isLocal: true, isDefinition: true)
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(scope: null, file: !22, line: 122, type: !23, isLocal: true, isDefinition: true)
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(scope: null, file: !22, line: 133, type: !23, isLocal: true, isDefinition: true)
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
!134 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !126, line: 171, type: !135, isLocal: true, isDefinition: true)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !136, size: 64)
!136 = !DISubroutineType(types: !137)
!137 = !{!138, !139, !141, null}
!138 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!139 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !140, size: 64)
!140 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!141 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !142, line: 27, baseType: !7)
!142 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 104, elements: !144)
!144 = !{!145}
!145 = !DISubrange(count: 13)
!146 = !{i32 7, !"Dwarf Version", i32 5}
!147 = !{i32 2, !"Debug Info Version", i32 3}
!148 = !{i32 1, !"wchar_size", i32 4}
!149 = !{i32 7, !"frame-pointer", i32 2}
!150 = !{!"Homebrew clang version 15.0.7"}
!151 = distinct !DISubprogram(name: "main_func", scope: !22, file: !22, line: 30, type: !152, scopeLine: 30, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !168)
!152 = !DISubroutineType(types: !153)
!153 = !{!62, !154}
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = !DIDerivedType(tag: DW_TAG_typedef, name: "syscalls_enter_args", file: !22, line: 23, baseType: !156)
!156 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_args", file: !22, line: 11, size: 512, elements: !157)
!157 = !{!158, !160, !162, !163, !164, !165}
!158 = !DIDerivedType(tag: DW_TAG_member, name: "common_type", scope: !156, file: !22, line: 17, baseType: !159, size: 16)
!159 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "common_flags", scope: !156, file: !22, line: 18, baseType: !161, size: 8, offset: 16)
!161 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "common_preempt_count", scope: !156, file: !22, line: 19, baseType: !161, size: 8, offset: 24)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "common_pid", scope: !156, file: !22, line: 20, baseType: !62, size: 32, offset: 32)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !156, file: !22, line: 21, baseType: !138, size: 64, offset: 64)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !156, file: !22, line: 22, baseType: !166, size: 384, offset: 128)
!166 = !DICompositeType(tag: DW_TAG_array_type, baseType: !167, size: 384, elements: !37)
!167 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!168 = !{!169, !170, !178, !179, !180, !220, !221, !224, !226, !231, !232, !235, !236, !237, !238, !242, !243, !248, !249, !254, !255, !256}
!169 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !151, file: !22, line: 30, type: !154)
!170 = !DILocalVariable(name: "str_param1", scope: !151, file: !22, line: 32, type: !171)
!171 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 105, baseType: !172)
!172 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 102, size: 16, elements: !173)
!173 = !{!174}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !172, file: !6, line: 104, baseType: !175, size: 16)
!175 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 16, elements: !176)
!176 = !{!177}
!177 = !DISubrange(count: 2)
!178 = !DILocalVariable(name: "str_param2", scope: !151, file: !22, line: 33, type: !171)
!179 = !DILocalVariable(name: "str_param3", scope: !151, file: !22, line: 34, type: !171)
!180 = !DILocalVariable(name: "op_result", scope: !151, file: !22, line: 36, type: !181)
!181 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !6, line: 100, baseType: !182)
!182 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !6, line: 95, size: 1472, elements: !183)
!183 = !{!184, !218, !219}
!184 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !182, file: !6, line: 97, baseType: !185, size: 192)
!185 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !6, line: 93, baseType: !186)
!186 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !6, line: 89, size: 192, elements: !187)
!187 = !{!188, !190}
!188 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !186, file: !6, line: 91, baseType: !189, size: 32)
!189 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !6, line: 52, baseType: !5)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !186, file: !6, line: 92, baseType: !191, size: 128, offset: 64)
!191 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !6, line: 87, baseType: !192)
!192 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !6, line: 79, size: 128, elements: !193)
!193 = !{!194, !195, !196, !198, !204, !210}
!194 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !192, file: !6, line: 81, baseType: !138, size: 64)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "u_integer", scope: !192, file: !6, line: 82, baseType: !7, size: 32)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "double_precision", scope: !192, file: !6, line: 83, baseType: !197, size: 64)
!197 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !192, file: !6, line: 84, baseType: !199, size: 64)
!199 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !6, line: 58, baseType: !200)
!200 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !6, line: 54, size: 64, elements: !201)
!201 = !{!202, !203}
!202 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !200, file: !6, line: 56, baseType: !62, size: 32)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !200, file: !6, line: 57, baseType: !62, size: 32, offset: 32)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !192, file: !6, line: 85, baseType: !205, size: 64)
!205 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !6, line: 64, baseType: !206)
!206 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !6, line: 60, size: 64, elements: !207)
!207 = !{!208, !209}
!208 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !206, file: !6, line: 62, baseType: !62, size: 32)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !206, file: !6, line: 63, baseType: !62, size: 32, offset: 32)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "syscalls_enter_kill_args", scope: !192, file: !6, line: 86, baseType: !211, size: 128)
!211 = !DIDerivedType(tag: DW_TAG_typedef, name: "struct_Syscalls_enter_kill_args", file: !6, line: 77, baseType: !212)
!212 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "struct_Syscalls_enter_kill_args", file: !6, line: 71, size: 128, elements: !213)
!213 = !{!214, !215, !216, !217}
!214 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pad", scope: !212, file: !6, line: 73, baseType: !7, size: 32)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "pos_syscall_nr", scope: !212, file: !6, line: 74, baseType: !7, size: 32, offset: 32)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pid", scope: !212, file: !6, line: 75, baseType: !7, size: 32, offset: 64)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "pos_sig", scope: !212, file: !6, line: 76, baseType: !7, size: 32, offset: 96)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !182, file: !6, line: 98, baseType: !62, size: 32, offset: 192)
!219 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !182, file: !6, line: 99, baseType: !23, size: 1200, offset: 224)
!220 = !DILocalVariable(name: "zero", scope: !151, file: !22, line: 38, type: !62)
!221 = !DILocalVariable(name: "string_pool", scope: !151, file: !22, line: 39, type: !222)
!222 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !223, size: 64)
!223 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 4000, elements: !74)
!224 = !DILocalVariable(name: "string_pool_index", scope: !151, file: !22, line: 46, type: !225)
!225 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!226 = !DILocalVariable(name: "heap", scope: !151, file: !22, line: 58, type: !227)
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !228, size: 64)
!228 = !DICompositeType(tag: DW_TAG_array_type, baseType: !185, size: 19200, elements: !229)
!229 = !{!230}
!230 = !DISubrange(count: 100)
!231 = !DILocalVariable(name: "heap_index", scope: !151, file: !22, line: 65, type: !225)
!232 = !DILocalVariable(name: "tuple_pool", scope: !151, file: !22, line: 73, type: !233)
!233 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !234, size: 64)
!234 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 16000, elements: !74)
!235 = !DILocalVariable(name: "tuple_pool_index", scope: !151, file: !22, line: 80, type: !225)
!236 = !DILocalVariable(name: "helper_var_68", scope: !151, file: !22, line: 90, type: !185)
!237 = !DILocalVariable(name: "helper_var_1410", scope: !151, file: !22, line: 91, type: !185)
!238 = !DILocalVariable(name: "____fmt", scope: !239, file: !22, line: 102, type: !36)
!239 = distinct !DILexicalBlock(scope: !240, file: !22, line: 102, column: 1)
!240 = distinct !DILexicalBlock(scope: !241, file: !22, line: 99, column: 30)
!241 = distinct !DILexicalBlock(scope: !151, file: !22, line: 99, column: 4)
!242 = !DILocalVariable(name: "helper_var_1538", scope: !240, file: !22, line: 103, type: !185)
!243 = !DILocalVariable(name: "____fmt", scope: !244, file: !22, line: 117, type: !41)
!244 = distinct !DILexicalBlock(scope: !245, file: !22, line: 117, column: 1)
!245 = distinct !DILexicalBlock(scope: !246, file: !22, line: 114, column: 30)
!246 = distinct !DILexicalBlock(scope: !247, file: !22, line: 114, column: 4)
!247 = distinct !DILexicalBlock(scope: !241, file: !22, line: 106, column: 8)
!248 = !DILocalVariable(name: "helper_var_1666", scope: !245, file: !22, line: 118, type: !185)
!249 = !DILocalVariable(name: "____fmt", scope: !250, file: !22, line: 139, type: !251)
!250 = distinct !DILexicalBlock(scope: !151, file: !22, line: 139, column: 3)
!251 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 56, elements: !252)
!252 = !{!253}
!253 = !DISubrange(count: 7)
!254 = !DILabel(scope: !151, name: "label_1474", file: !22, line: 98)
!255 = !DILabel(scope: !247, name: "label_1602", file: !22, line: 113)
!256 = !DILabel(scope: !151, name: "CATCH", file: !22, line: 138)
!257 = !DILocation(line: 32, column: 15, scope: !151)
!258 = !DILocation(line: 33, column: 15, scope: !151)
!259 = !DILocation(line: 34, column: 15, scope: !151)
!260 = !DILocation(line: 0, scope: !151)
!261 = !DILocation(line: 36, column: 1, scope: !151)
!262 = !DILocation(line: 36, column: 10, scope: !151)
!263 = !DILocation(line: 38, column: 1, scope: !151)
!264 = !DILocation(line: 38, column: 5, scope: !151)
!265 = !{!266, !266, i64 0}
!266 = !{!"int", !267, i64 0}
!267 = !{!"omnipotent char", !268, i64 0}
!268 = !{!"Simple C/C++ TBAA"}
!269 = !DILocation(line: 39, column: 40, scope: !151)
!270 = !DILocation(line: 40, column: 6, scope: !271)
!271 = distinct !DILexicalBlock(scope: !151, file: !22, line: 40, column: 5)
!272 = !DILocation(line: 40, column: 5, scope: !151)
!273 = !DILocation(line: 42, column: 25, scope: !274)
!274 = distinct !DILexicalBlock(scope: !271, file: !22, line: 41, column: 1)
!275 = !DILocation(line: 42, column: 15, scope: !274)
!276 = !{i64 0, i64 4, !265, i64 4, i64 150, !277}
!277 = !{!267, !267, i64 0}
!278 = !{i64 0, i64 150, !277}
!279 = !DILocation(line: 43, column: 3, scope: !274)
!280 = !DILocation(line: 46, column: 31, scope: !151)
!281 = !DILocation(line: 47, column: 6, scope: !282)
!282 = distinct !DILexicalBlock(scope: !151, file: !22, line: 47, column: 5)
!283 = !DILocation(line: 47, column: 5, scope: !151)
!284 = !DILocation(line: 49, column: 25, scope: !285)
!285 = distinct !DILexicalBlock(scope: !282, file: !22, line: 48, column: 1)
!286 = !DILocation(line: 49, column: 15, scope: !285)
!287 = !DILocation(line: 50, column: 3, scope: !285)
!288 = !DILocation(line: 52, column: 20, scope: !151)
!289 = !DILocation(line: 54, column: 1, scope: !151)
!290 = !DILocation(line: 55, column: 31, scope: !151)
!291 = !DILocation(line: 55, column: 1, scope: !151)
!292 = !DILocation(line: 56, column: 35, scope: !151)
!293 = !DILocation(line: 56, column: 1, scope: !151)
!294 = !DILocation(line: 58, column: 29, scope: !151)
!295 = !DILocation(line: 59, column: 6, scope: !296)
!296 = distinct !DILexicalBlock(scope: !151, file: !22, line: 59, column: 5)
!297 = !DILocation(line: 59, column: 5, scope: !151)
!298 = !DILocation(line: 61, column: 25, scope: !299)
!299 = distinct !DILexicalBlock(scope: !296, file: !22, line: 60, column: 1)
!300 = !DILocation(line: 61, column: 15, scope: !299)
!301 = !DILocation(line: 62, column: 3, scope: !299)
!302 = !DILocation(line: 65, column: 24, scope: !151)
!303 = !DILocation(line: 66, column: 6, scope: !304)
!304 = distinct !DILexicalBlock(scope: !151, file: !22, line: 66, column: 5)
!305 = !DILocation(line: 66, column: 5, scope: !151)
!306 = !DILocation(line: 68, column: 25, scope: !307)
!307 = distinct !DILexicalBlock(scope: !304, file: !22, line: 67, column: 1)
!308 = !DILocation(line: 68, column: 15, scope: !307)
!309 = !DILocation(line: 69, column: 3, scope: !307)
!310 = !DILocation(line: 71, column: 13, scope: !151)
!311 = !DILocation(line: 73, column: 43, scope: !151)
!312 = !DILocation(line: 74, column: 6, scope: !313)
!313 = distinct !DILexicalBlock(scope: !151, file: !22, line: 74, column: 5)
!314 = !DILocation(line: 74, column: 5, scope: !151)
!315 = !DILocation(line: 76, column: 25, scope: !316)
!316 = distinct !DILexicalBlock(scope: !313, file: !22, line: 75, column: 1)
!317 = !DILocation(line: 76, column: 15, scope: !316)
!318 = !DILocation(line: 77, column: 3, scope: !316)
!319 = !DILocation(line: 80, column: 30, scope: !151)
!320 = !DILocation(line: 81, column: 6, scope: !321)
!321 = distinct !DILexicalBlock(scope: !151, file: !22, line: 81, column: 5)
!322 = !DILocation(line: 81, column: 5, scope: !151)
!323 = !DILocation(line: 83, column: 25, scope: !324)
!324 = distinct !DILexicalBlock(scope: !321, file: !22, line: 82, column: 1)
!325 = !DILocation(line: 83, column: 15, scope: !324)
!326 = !DILocation(line: 84, column: 3, scope: !324)
!327 = !DILocation(line: 86, column: 19, scope: !151)
!328 = !DILocation(line: 98, column: 1, scope: !151)
!329 = !DILocation(line: 113, column: 1, scope: !247)
!330 = !DILocation(line: 117, column: 1, scope: !244)
!331 = !DILocation(line: 117, column: 1, scope: !245)
!332 = !DILocation(line: 0, scope: !245)
!333 = !DILocation(line: 138, column: 1, scope: !151)
!334 = !DILocation(line: 139, column: 3, scope: !250)
!335 = !DILocation(line: 139, column: 3, scope: !151)
!336 = !DILocation(line: 140, column: 3, scope: !151)
!337 = !DILocation(line: 142, column: 1, scope: !151)
