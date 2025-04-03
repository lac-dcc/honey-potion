; ModuleID = '/home/adrianosantos/workspaces/git/me/honey-potion/test/src/HoneyTest.JustCompiles.bpf.c'
source_filename = "/home/adrianosantos/workspaces/git/me/honey-potion/test/src/HoneyTest.JustCompiles.bpf.c"
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
%union.ElixirValue = type { i64 }

@LICENSE = global [5 x i8] c"oops\00", section "license", align 1, !dbg !0
@string_pool_map = global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !128
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !19
@string_pool_index_map = global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !147
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !26
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1, !dbg !28
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1, !dbg !33
@heap_map = global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !175
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !43
@heap_index_map = global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !187
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4, !dbg !45
@tuple_pool_map = global %struct.anon.3 zeroinitializer, section ".maps", align 8, !dbg !155
@tuple_pool_index_map = global %struct.anon.4 zeroinitializer, section ".maps", align 8, !dbg !167
@main_func.____fmt = internal constant [7 x i8] c"** %s\0A\00", align 1, !dbg !47
@llvm.compiler.used = appending global [8 x ptr] [ptr @LICENSE, ptr @heap_index_map, ptr @heap_map, ptr @main_func, ptr @string_pool_index_map, ptr @string_pool_map, ptr @tuple_pool_index_map, ptr @tuple_pool_map], section "llvm.metadata"

; Function Attrs: nounwind
define range(i32 0, 2) i32 @main_func(ptr nocapture readnone %0) #0 section "tracepoint/syscalls/sys_enter_kill" !dbg !49 {
  %2 = alloca %struct.OpResult, align 8, !DIAssignID !219
    #dbg_assign(i1 undef, !75, !DIExpression(), !219, ptr %2, !DIExpression(), !220)
  %3 = alloca i32, align 4, !DIAssignID !221
    #dbg_assign(i1 undef, !104, !DIExpression(), !221, ptr %3, !DIExpression(), !220)
    #dbg_value(ptr poison, !64, !DIExpression(), !220)
  call void @llvm.lifetime.start.p0(i64 176, ptr nonnull %2) #4, !dbg !222
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(176) %2, i8 0, i64 176, i1 false), !dbg !223, !DIAssignID !224
    #dbg_assign(i8 0, !75, !DIExpression(), !224, ptr %2, !DIExpression(), !220)
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #4, !dbg !225
  store i32 0, ptr %3, align 4, !dbg !226, !tbaa !227, !DIAssignID !231
    #dbg_assign(i32 0, !104, !DIExpression(), !231, ptr %3, !DIExpression(), !220)
  %4 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_map, ptr noundef nonnull %3) #4, !dbg !232
    #dbg_value(ptr %4, !105, !DIExpression(), !220)
  %5 = icmp eq ptr %4, null, !dbg !233
  br i1 %5, label %6, label %9, !dbg !235

6:                                                ; preds = %1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false), !dbg !236
  %7 = getelementptr inbounds i8, ptr %2, i64 16, !dbg !238
  store i32 1, ptr %7, align 8, !dbg !238, !tbaa !227, !DIAssignID !239
  %8 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !238
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %8, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !238, !tbaa.struct !240, !DIAssignID !242
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !243, ptr %2, !DIExpression(), !220)
    #dbg_assign(i32 1, !75, !DIExpression(DW_OP_LLVM_fragment, 128, 32), !239, ptr %7, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 160, 1200), !242, ptr %8, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 1360, 48), !244, ptr %2, !DIExpression(DW_OP_plus_uconst, 170), !220)
  br label %42, !dbg !245

9:                                                ; preds = %1
  %10 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @string_pool_index_map, ptr noundef nonnull %3) #4, !dbg !246
    #dbg_value(ptr %10, !110, !DIExpression(), !220)
  %11 = icmp eq ptr %10, null, !dbg !247
  br i1 %11, label %12, label %15, !dbg !249

12:                                               ; preds = %9
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false), !dbg !250
  %13 = getelementptr inbounds i8, ptr %2, i64 16, !dbg !252
  store i32 1, ptr %13, align 8, !dbg !252, !tbaa !227, !DIAssignID !253
  %14 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !252
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %14, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !252, !tbaa.struct !240, !DIAssignID !254
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !255, ptr %2, !DIExpression(), !220)
    #dbg_assign(i32 1, !75, !DIExpression(DW_OP_LLVM_fragment, 128, 32), !253, ptr %13, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 160, 1200), !254, ptr %14, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 1360, 48), !256, ptr %2, !DIExpression(DW_OP_plus_uconst, 170), !220)
  br label %42, !dbg !257

15:                                               ; preds = %9
  store i32 0, ptr %10, align 4, !dbg !258, !tbaa !227
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(3) %4, ptr noundef nonnull align 1 dereferenceable(3) @.str.2, i64 3, i1 false), !dbg !259
  %16 = getelementptr i8, ptr %4, i64 3, !dbg !260
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(5) %16, ptr noundef nonnull align 1 dereferenceable(5) @.str.3, i64 5, i1 false), !dbg !261
  %17 = getelementptr i8, ptr %4, i64 8, !dbg !262
  store i32 1702195828, ptr %17, align 1, !dbg !263
  %18 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_map, ptr noundef nonnull %3) #4, !dbg !264
    #dbg_value(ptr %18, !112, !DIExpression(), !220)
  %19 = icmp eq ptr %18, null, !dbg !265
  br i1 %19, label %20, label %23, !dbg !267

20:                                               ; preds = %15
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false), !dbg !268
  %21 = getelementptr inbounds i8, ptr %2, i64 16, !dbg !270
  store i32 1, ptr %21, align 8, !dbg !270, !tbaa !227, !DIAssignID !271
  %22 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !270
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %22, ptr noundef nonnull align 4 dereferenceable(150) @.str.5, i64 150, i1 false), !dbg !270, !tbaa.struct !240, !DIAssignID !272
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !273, ptr %2, !DIExpression(), !220)
    #dbg_assign(i32 1, !75, !DIExpression(DW_OP_LLVM_fragment, 128, 32), !271, ptr %21, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 160, 1200), !272, ptr %22, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 1360, 48), !274, ptr %2, !DIExpression(DW_OP_plus_uconst, 170), !220)
  br label %42, !dbg !275

23:                                               ; preds = %15
  %24 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap_index_map, ptr noundef nonnull %3) #4, !dbg !276
    #dbg_value(ptr %24, !117, !DIExpression(), !220)
  %25 = icmp eq ptr %24, null, !dbg !277
  br i1 %25, label %26, label %29, !dbg !279

26:                                               ; preds = %23
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false), !dbg !280
  %27 = getelementptr inbounds i8, ptr %2, i64 16, !dbg !282
  store i32 1, ptr %27, align 8, !dbg !282, !tbaa !227, !DIAssignID !283
  %28 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !282
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %28, ptr noundef nonnull align 4 dereferenceable(150) @.str.6, i64 150, i1 false), !dbg !282, !tbaa.struct !240, !DIAssignID !284
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !285, ptr %2, !DIExpression(), !220)
    #dbg_assign(i32 1, !75, !DIExpression(DW_OP_LLVM_fragment, 128, 32), !283, ptr %27, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 160, 1200), !284, ptr %28, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 1360, 48), !286, ptr %2, !DIExpression(DW_OP_plus_uconst, 170), !220)
  br label %42, !dbg !287

29:                                               ; preds = %23
  store i32 0, ptr %24, align 4, !dbg !288, !tbaa !227
  %30 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_map, ptr noundef nonnull %3) #4, !dbg !289
    #dbg_value(ptr %30, !118, !DIExpression(), !220)
  %31 = icmp eq ptr %30, null, !dbg !290
  br i1 %31, label %32, label %35, !dbg !292

32:                                               ; preds = %29
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false), !dbg !293
  %33 = getelementptr inbounds i8, ptr %2, i64 16, !dbg !295
  store i32 1, ptr %33, align 8, !dbg !295, !tbaa !227, !DIAssignID !296
  %34 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !295
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %34, ptr noundef nonnull align 4 dereferenceable(150) @.str, i64 150, i1 false), !dbg !295, !tbaa.struct !240, !DIAssignID !297
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !298, ptr %2, !DIExpression(), !220)
    #dbg_assign(i32 1, !75, !DIExpression(DW_OP_LLVM_fragment, 128, 32), !296, ptr %33, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 160, 1200), !297, ptr %34, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 1360, 48), !299, ptr %2, !DIExpression(DW_OP_plus_uconst, 170), !220)
  br label %42, !dbg !300

35:                                               ; preds = %29
  %36 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @tuple_pool_index_map, ptr noundef nonnull %3) #4, !dbg !301
    #dbg_value(ptr %36, !121, !DIExpression(), !220)
  %37 = icmp eq ptr %36, null, !dbg !302
  br i1 %37, label %38, label %41, !dbg !304

38:                                               ; preds = %35
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %2, i8 0, i64 16, i1 false), !dbg !305
  %39 = getelementptr inbounds i8, ptr %2, i64 16, !dbg !307
  store i32 1, ptr %39, align 8, !dbg !307, !tbaa !227, !DIAssignID !308
  %40 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !307
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(150) %40, ptr noundef nonnull align 4 dereferenceable(150) @.str.1, i64 150, i1 false), !dbg !307, !tbaa.struct !240, !DIAssignID !309
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 0, 128), !310, ptr %2, !DIExpression(), !220)
    #dbg_assign(i32 1, !75, !DIExpression(DW_OP_LLVM_fragment, 128, 32), !308, ptr %39, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 160, 1200), !309, ptr %40, !DIExpression(), !220)
    #dbg_assign(i1 undef, !75, !DIExpression(DW_OP_LLVM_fragment, 1360, 48), !311, ptr %2, !DIExpression(DW_OP_plus_uconst, 170), !220)
  br label %42, !dbg !312

41:                                               ; preds = %35
  store i32 0, ptr %36, align 4, !dbg !313, !tbaa !227
    #dbg_value(i32 1, !122, !DIExpression(), !220)
  br label %45, !dbg !314

42:                                               ; preds = %38, %32, %26, %20, %12, %6
    #dbg_label(!123, !315)
  %43 = getelementptr inbounds i8, ptr %2, i64 20, !dbg !316
  %44 = call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @main_func.____fmt, i32 noundef 7, ptr noundef nonnull %43) #4, !dbg !316
  br label %45, !dbg !318

45:                                               ; preds = %42, %41
  %46 = phi i32 [ 1, %41 ], [ 0, %42 ], !dbg !220
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #4, !dbg !319
  call void @llvm.lifetime.end.p0(i64 176, ptr nonnull %2) #4, !dbg !319
  ret i32 %46, !dbg !319
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

attributes #0 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!212, !213, !214, !215, !216, !217}
!llvm.ident = !{!218}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !21, line: 24, type: !40, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 19.1.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !18, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/adrianosantos/workspaces/git/me/honey-potion/test/src/HoneyTest.JustCompiles.bpf.c", directory: "/home/adrianosantos/workspaces/git/me/honey-potion/test", checksumkind: CSK_MD5, checksum: "6d1658e7fffa4781da4333c196e89689")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Type", file: !6, line: 40, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "_build/test/lib/honey/priv/c_boilerplates/runtime_generic.bpf.h", directory: "/home/adrianosantos/workspaces/git/me/honey-potion", checksumkind: CSK_MD5, checksum: "5909da53d5dff54416a176cb54def0a4")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17}
!9 = !DIEnumerator(name: "INVALID_TYPE", value: 0)
!10 = !DIEnumerator(name: "PATTERN_M", value: 1)
!11 = !DIEnumerator(name: "INTEGER", value: 2)
!12 = !DIEnumerator(name: "DOUBLE", value: 3)
!13 = !DIEnumerator(name: "STRING", value: 4)
!14 = !DIEnumerator(name: "ATOM", value: 5)
!15 = !DIEnumerator(name: "TUPLE", value: 6)
!16 = !DIEnumerator(name: "LIST", value: 7)
!17 = !DIEnumerator(name: "STRUCT", value: 8)
!18 = !{!0, !19, !26, !28, !33, !38, !43, !45, !47, !128, !147, !155, !167, !175, !187, !195, !204}
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(scope: null, file: !21, line: 41, type: !22, isLocal: true, isDefinition: true)
!21 = !DIFile(filename: "src/HoneyTest.JustCompiles.bpf.c", directory: "/home/adrianosantos/workspaces/git/me/honey-potion/test", checksumkind: CSK_MD5, checksum: "6d1658e7fffa4781da4333c196e89689")
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 1200, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 150)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(scope: null, file: !21, line: 48, type: !22, isLocal: true, isDefinition: true)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(scope: null, file: !21, line: 53, type: !30, isLocal: true, isDefinition: true)
!30 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !31)
!31 = !{!32}
!32 = !DISubrange(count: 4)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(scope: null, file: !21, line: 54, type: !35, isLocal: true, isDefinition: true)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 48, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 6)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(scope: null, file: !21, line: 55, type: !40, isLocal: true, isDefinition: true)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 40, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 5)
!43 = !DIGlobalVariableExpression(var: !44, expr: !DIExpression())
!44 = distinct !DIGlobalVariable(scope: null, file: !21, line: 60, type: !22, isLocal: true, isDefinition: true)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(scope: null, file: !21, line: 67, type: !22, isLocal: true, isDefinition: true)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "____fmt", scope: !49, file: !21, line: 93, type: !124, isLocal: true, isDefinition: true)
!49 = distinct !DISubprogram(name: "main_func", scope: !21, file: !21, line: 29, type: !50, scopeLine: 29, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !63)
!50 = !DISubroutineType(types: !51)
!51 = !{!52, !53}
!52 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "syscalls_enter_kill_args", file: !21, line: 22, baseType: !55)
!55 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_kill_args", file: !21, line: 11, size: 256, elements: !56)
!56 = !{!57, !59, !61, !62}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !55, file: !21, line: 17, baseType: !58, size: 64)
!58 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "syscall_nr", scope: !55, file: !21, line: 19, baseType: !60, size: 64, offset: 64)
!60 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !55, file: !21, line: 20, baseType: !60, size: 64, offset: 128)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "sig", scope: !55, file: !21, line: 21, baseType: !60, size: 64, offset: 192)
!63 = !{!64, !65, !73, !74, !75, !104, !105, !110, !112, !117, !118, !121, !122, !123}
!64 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !49, file: !21, line: 29, type: !53)
!65 = !DILocalVariable(name: "str_param1", scope: !49, file: !21, line: 31, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 93, baseType: !67)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 90, size: 16, elements: !68)
!68 = !{!69}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !67, file: !6, line: 92, baseType: !70, size: 16)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 16, elements: !71)
!71 = !{!72}
!72 = !DISubrange(count: 2)
!73 = !DILocalVariable(name: "str_param2", scope: !49, file: !21, line: 32, type: !66)
!74 = !DILocalVariable(name: "str_param3", scope: !49, file: !21, line: 33, type: !66)
!75 = !DILocalVariable(name: "op_result", scope: !49, file: !21, line: 35, type: !76)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !6, line: 88, baseType: !77)
!77 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !6, line: 83, size: 1408, elements: !78)
!78 = !{!79, !102, !103}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !77, file: !6, line: 85, baseType: !80, size: 128)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !6, line: 81, baseType: !81)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !6, line: 77, size: 128, elements: !82)
!82 = !{!83, !85}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !81, file: !6, line: 79, baseType: !84, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !6, line: 51, baseType: !5)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !81, file: !6, line: 80, baseType: !86, size: 64, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !6, line: 75, baseType: !87)
!87 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !6, line: 70, size: 64, elements: !88)
!88 = !{!89, !90, !96}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !87, file: !6, line: 72, baseType: !60, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !87, file: !6, line: 73, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !6, line: 57, baseType: !92)
!92 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !6, line: 53, size: 64, elements: !93)
!93 = !{!94, !95}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !92, file: !6, line: 55, baseType: !52, size: 32)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !92, file: !6, line: 56, baseType: !52, size: 32, offset: 32)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !87, file: !6, line: 74, baseType: !97, size: 64)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !6, line: 63, baseType: !98)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !6, line: 59, size: 64, elements: !99)
!99 = !{!100, !101}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !98, file: !6, line: 61, baseType: !52, size: 32)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !98, file: !6, line: 62, baseType: !52, size: 32, offset: 32)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !77, file: !6, line: 86, baseType: !52, size: 32, offset: 128)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !77, file: !6, line: 87, baseType: !22, size: 1200, offset: 160)
!104 = !DILocalVariable(name: "zero", scope: !49, file: !21, line: 37, type: !52)
!105 = !DILocalVariable(name: "string_pool", scope: !49, file: !21, line: 38, type: !106)
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !107, size: 64)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 4000, elements: !108)
!108 = !{!109}
!109 = !DISubrange(count: 500)
!110 = !DILocalVariable(name: "string_pool_index", scope: !49, file: !21, line: 45, type: !111)
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!112 = !DILocalVariable(name: "heap", scope: !49, file: !21, line: 57, type: !113)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DICompositeType(tag: DW_TAG_array_type, baseType: !80, size: 12800, elements: !115)
!115 = !{!116}
!116 = !DISubrange(count: 100)
!117 = !DILocalVariable(name: "heap_index", scope: !49, file: !21, line: 64, type: !111)
!118 = !DILocalVariable(name: "tuple_pool", scope: !49, file: !21, line: 72, type: !119)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 16000, elements: !108)
!121 = !DILocalVariable(name: "tuple_pool_index", scope: !49, file: !21, line: 79, type: !111)
!122 = !DILocalVariable(name: "helper_var_1634", scope: !49, file: !21, line: 88, type: !52)
!123 = !DILabel(scope: !49, name: "CATCH", file: !21, line: 92)
!124 = !DICompositeType(tag: DW_TAG_array_type, baseType: !125, size: 56, elements: !126)
!125 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!126 = !{!127}
!127 = !DISubrange(count: 7)
!128 = !DIGlobalVariableExpression(var: !129, expr: !DIExpression())
!129 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !130, line: 19, type: !131, isLocal: false, isDefinition: true)
!130 = !DIFile(filename: "_build/test/lib/honey/priv/c_boilerplates/runtime_structures.bpf.h", directory: "/home/adrianosantos/workspaces/git/me/honey-potion", checksumkind: CSK_MD5, checksum: "c2bd38c05cd37ff863c88000051eef3c")
!131 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !130, line: 13, size: 256, elements: !132)
!132 = !{!133, !136, !141, !144}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !131, file: !130, line: 15, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 192, elements: !36)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !131, file: !130, line: 16, baseType: !137, size: 64, offset: 64)
!137 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !138, size: 64)
!138 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 32, elements: !139)
!139 = !{!140}
!140 = !DISubrange(count: 1)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !131, file: !130, line: 17, baseType: !142, size: 64, offset: 128)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 128, elements: !31)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !131, file: !130, line: 18, baseType: !145, size: 64, offset: 192)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 16000, elements: !108)
!147 = !DIGlobalVariableExpression(var: !148, expr: !DIExpression())
!148 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !130, line: 27, type: !149, isLocal: false, isDefinition: true)
!149 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !130, line: 21, size: 256, elements: !150)
!150 = !{!151, !152, !153, !154}
!151 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !149, file: !130, line: 23, baseType: !134, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !149, file: !130, line: 24, baseType: !137, size: 64, offset: 64)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !149, file: !130, line: 25, baseType: !142, size: 64, offset: 128)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !149, file: !130, line: 26, baseType: !142, size: 64, offset: 192)
!155 = !DIGlobalVariableExpression(var: !156, expr: !DIExpression())
!156 = distinct !DIGlobalVariable(name: "tuple_pool_map", scope: !2, file: !130, line: 36, type: !157, isLocal: false, isDefinition: true)
!157 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !130, line: 30, size: 256, elements: !158)
!158 = !{!159, !160, !161, !162}
!159 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !157, file: !130, line: 32, baseType: !134, size: 64)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !157, file: !130, line: 33, baseType: !137, size: 64, offset: 64)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !157, file: !130, line: 34, baseType: !142, size: 64, offset: 128)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !157, file: !130, line: 35, baseType: !163, size: 64, offset: 192)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 64000, elements: !165)
!165 = !{!166}
!166 = !DISubrange(count: 2000)
!167 = !DIGlobalVariableExpression(var: !168, expr: !DIExpression())
!168 = distinct !DIGlobalVariable(name: "tuple_pool_index_map", scope: !2, file: !130, line: 44, type: !169, isLocal: false, isDefinition: true)
!169 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !130, line: 38, size: 256, elements: !170)
!170 = !{!171, !172, !173, !174}
!171 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !169, file: !130, line: 40, baseType: !134, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !169, file: !130, line: 41, baseType: !137, size: 64, offset: 64)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !169, file: !130, line: 42, baseType: !142, size: 64, offset: 128)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !169, file: !130, line: 43, baseType: !142, size: 64, offset: 192)
!175 = !DIGlobalVariableExpression(var: !176, expr: !DIExpression())
!176 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !130, line: 53, type: !177, isLocal: false, isDefinition: true)
!177 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !130, line: 47, size: 256, elements: !178)
!178 = !{!179, !180, !181, !182}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !177, file: !130, line: 49, baseType: !134, size: 64)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !177, file: !130, line: 50, baseType: !137, size: 64, offset: 64)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !177, file: !130, line: 51, baseType: !142, size: 64, offset: 128)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !177, file: !130, line: 52, baseType: !183, size: 64, offset: 192)
!183 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !184, size: 64)
!184 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 51200, elements: !185)
!185 = !{!186}
!186 = !DISubrange(count: 1600)
!187 = !DIGlobalVariableExpression(var: !188, expr: !DIExpression())
!188 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !130, line: 61, type: !189, isLocal: false, isDefinition: true)
!189 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !130, line: 55, size: 256, elements: !190)
!190 = !{!191, !192, !193, !194}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !189, file: !130, line: 57, baseType: !134, size: 64)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !189, file: !130, line: 58, baseType: !137, size: 64, offset: 64)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !189, file: !130, line: 59, baseType: !142, size: 64, offset: 128)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !189, file: !130, line: 60, baseType: !142, size: 64, offset: 192)
!195 = !DIGlobalVariableExpression(var: !196, expr: !DIExpression(DW_OP_constu, 1, DW_OP_stack_value))
!196 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !197, line: 56, type: !198, isLocal: true, isDefinition: true)
!197 = !DIFile(filename: "/nix/store/zwkvkdvmldsqixfkj4cwg9xm89bjhn7d-libbpf-1.1.0/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "ba0039f6acc4710a5f4349e628ddfb60")
!198 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !199, size: 64)
!199 = !DISubroutineType(types: !200)
!200 = !{!201, !201, !202}
!201 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!202 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !203, size: 64)
!203 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!204 = !DIGlobalVariableExpression(var: !205, expr: !DIExpression(DW_OP_constu, 6, DW_OP_stack_value))
!205 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !197, line: 177, type: !206, isLocal: true, isDefinition: true)
!206 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !207, size: 64)
!207 = !DISubroutineType(types: !208)
!208 = !{!60, !209, !210, null}
!209 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!210 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !211, line: 27, baseType: !7)
!211 = !DIFile(filename: "/nix/store/5djq7mrpqv8kzn2xi22y5d8ww7rsix82-glibc-2.40-66-dev/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!212 = !{i32 7, !"Dwarf Version", i32 5}
!213 = !{i32 2, !"Debug Info Version", i32 3}
!214 = !{i32 1, !"wchar_size", i32 4}
!215 = !{i32 8, !"PIC Level", i32 2}
!216 = !{i32 7, !"frame-pointer", i32 2}
!217 = !{i32 7, !"debug-info-assignment-tracking", i1 true}
!218 = !{!"clang version 19.1.7"}
!219 = distinct !DIAssignID()
!220 = !DILocation(line: 0, scope: !49)
!221 = distinct !DIAssignID()
!222 = !DILocation(line: 35, column: 1, scope: !49)
!223 = !DILocation(line: 35, column: 10, scope: !49)
!224 = distinct !DIAssignID()
!225 = !DILocation(line: 37, column: 1, scope: !49)
!226 = !DILocation(line: 37, column: 5, scope: !49)
!227 = !{!228, !228, i64 0}
!228 = !{!"int", !229, i64 0}
!229 = !{!"omnipotent char", !230, i64 0}
!230 = !{!"Simple C/C++ TBAA"}
!231 = distinct !DIAssignID()
!232 = !DILocation(line: 38, column: 40, scope: !49)
!233 = !DILocation(line: 39, column: 6, scope: !234)
!234 = distinct !DILexicalBlock(scope: !49, file: !21, line: 39, column: 5)
!235 = !DILocation(line: 39, column: 5, scope: !49)
!236 = !DILocation(line: 41, column: 25, scope: !237)
!237 = distinct !DILexicalBlock(scope: !234, file: !21, line: 40, column: 1)
!238 = !DILocation(line: 41, column: 15, scope: !237)
!239 = distinct !DIAssignID()
!240 = !{i64 0, i64 150, !241}
!241 = !{!229, !229, i64 0}
!242 = distinct !DIAssignID()
!243 = distinct !DIAssignID()
!244 = distinct !DIAssignID()
!245 = !DILocation(line: 42, column: 3, scope: !237)
!246 = !DILocation(line: 45, column: 31, scope: !49)
!247 = !DILocation(line: 46, column: 6, scope: !248)
!248 = distinct !DILexicalBlock(scope: !49, file: !21, line: 46, column: 5)
!249 = !DILocation(line: 46, column: 5, scope: !49)
!250 = !DILocation(line: 48, column: 25, scope: !251)
!251 = distinct !DILexicalBlock(scope: !248, file: !21, line: 47, column: 1)
!252 = !DILocation(line: 48, column: 15, scope: !251)
!253 = distinct !DIAssignID()
!254 = distinct !DIAssignID()
!255 = distinct !DIAssignID()
!256 = distinct !DIAssignID()
!257 = !DILocation(line: 49, column: 3, scope: !251)
!258 = !DILocation(line: 51, column: 20, scope: !49)
!259 = !DILocation(line: 53, column: 1, scope: !49)
!260 = !DILocation(line: 54, column: 31, scope: !49)
!261 = !DILocation(line: 54, column: 1, scope: !49)
!262 = !DILocation(line: 55, column: 35, scope: !49)
!263 = !DILocation(line: 55, column: 1, scope: !49)
!264 = !DILocation(line: 57, column: 29, scope: !49)
!265 = !DILocation(line: 58, column: 6, scope: !266)
!266 = distinct !DILexicalBlock(scope: !49, file: !21, line: 58, column: 5)
!267 = !DILocation(line: 58, column: 5, scope: !49)
!268 = !DILocation(line: 60, column: 25, scope: !269)
!269 = distinct !DILexicalBlock(scope: !266, file: !21, line: 59, column: 1)
!270 = !DILocation(line: 60, column: 15, scope: !269)
!271 = distinct !DIAssignID()
!272 = distinct !DIAssignID()
!273 = distinct !DIAssignID()
!274 = distinct !DIAssignID()
!275 = !DILocation(line: 61, column: 3, scope: !269)
!276 = !DILocation(line: 64, column: 24, scope: !49)
!277 = !DILocation(line: 65, column: 6, scope: !278)
!278 = distinct !DILexicalBlock(scope: !49, file: !21, line: 65, column: 5)
!279 = !DILocation(line: 65, column: 5, scope: !49)
!280 = !DILocation(line: 67, column: 25, scope: !281)
!281 = distinct !DILexicalBlock(scope: !278, file: !21, line: 66, column: 1)
!282 = !DILocation(line: 67, column: 15, scope: !281)
!283 = distinct !DIAssignID()
!284 = distinct !DIAssignID()
!285 = distinct !DIAssignID()
!286 = distinct !DIAssignID()
!287 = !DILocation(line: 68, column: 3, scope: !281)
!288 = !DILocation(line: 70, column: 13, scope: !49)
!289 = !DILocation(line: 72, column: 43, scope: !49)
!290 = !DILocation(line: 73, column: 6, scope: !291)
!291 = distinct !DILexicalBlock(scope: !49, file: !21, line: 73, column: 5)
!292 = !DILocation(line: 73, column: 5, scope: !49)
!293 = !DILocation(line: 75, column: 25, scope: !294)
!294 = distinct !DILexicalBlock(scope: !291, file: !21, line: 74, column: 1)
!295 = !DILocation(line: 75, column: 15, scope: !294)
!296 = distinct !DIAssignID()
!297 = distinct !DIAssignID()
!298 = distinct !DIAssignID()
!299 = distinct !DIAssignID()
!300 = !DILocation(line: 76, column: 3, scope: !294)
!301 = !DILocation(line: 79, column: 30, scope: !49)
!302 = !DILocation(line: 80, column: 6, scope: !303)
!303 = distinct !DILexicalBlock(scope: !49, file: !21, line: 80, column: 5)
!304 = !DILocation(line: 80, column: 5, scope: !49)
!305 = !DILocation(line: 82, column: 25, scope: !306)
!306 = distinct !DILexicalBlock(scope: !303, file: !21, line: 81, column: 1)
!307 = !DILocation(line: 82, column: 15, scope: !306)
!308 = distinct !DIAssignID()
!309 = distinct !DIAssignID()
!310 = distinct !DIAssignID()
!311 = distinct !DIAssignID()
!312 = !DILocation(line: 83, column: 3, scope: !306)
!313 = !DILocation(line: 85, column: 19, scope: !49)
!314 = !DILocation(line: 91, column: 1, scope: !49)
!315 = !DILocation(line: 92, column: 1, scope: !49)
!316 = !DILocation(line: 93, column: 3, scope: !317)
!317 = distinct !DILexicalBlock(scope: !49, file: !21, line: 93, column: 3)
!318 = !DILocation(line: 94, column: 3, scope: !49)
!319 = !DILocation(line: 96, column: 1, scope: !49)
