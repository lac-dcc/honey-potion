; ModuleID = './src/HoneyTest.JustCompiles.bpf.c'
source_filename = "./src/HoneyTest.JustCompiles.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [500 x i32]* }
%struct.anon.0 = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [4 x i32]* }
%struct.anon.1 = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [2400 x i32]* }
%struct.anon.2 = type { [6 x i32]*, [1 x i32]*, [4 x i32]*, [4 x i32]* }
%struct.syscalls_enter_kill_args = type { i64, i64, i64, i64 }
%struct.OpResult = type { %struct.Generic, i32, [150 x i8] }
%struct.Generic = type { i32, %union.ElixirValue }
%union.ElixirValue = type { double, [8 x i8] }

@LICENSE = dso_local global [5 x i8] c"oops\00", section "license", align 1, !dbg !0
@string_pool_map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !114
@.str = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@string_pool_index_map = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !136
@.str.1 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access string pool index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@.str.2 = private unnamed_addr constant [4 x i8] c"nil\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"false\00", align 1
@heap_map = dso_local global %struct.anon.1 zeroinitializer, section ".maps", align 8, !dbg !144
@.str.5 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@heap_index_map = dso_local global %struct.anon.2 zeroinitializer, section ".maps", align 8, !dbg !156
@.str.6 = private unnamed_addr constant [150 x i8] c"(UnexpectedBehavior) something wrong happened inside the Elixir runtime for eBPF. (can't access heap map index, main function).\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 4
@main_func.____fmt = internal constant [7 x i8] c"** %s\0A\00", align 1, !dbg !20
@llvm.compiler.used = appending global [6 x i8*] [i8* getelementptr inbounds ([5 x i8], [5 x i8]* @LICENSE, i32 0, i32 0), i8* bitcast (%struct.anon.2* @heap_index_map to i8*), i8* bitcast (%struct.anon.1* @heap_map to i8*), i8* bitcast (i32 (%struct.syscalls_enter_kill_args*)* @main_func to i8*), i8* bitcast (%struct.anon.0* @string_pool_index_map to i8*), i8* bitcast (%struct.anon* @string_pool_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @main_func(%struct.syscalls_enter_kill_args* nocapture noundef readonly %0) #0 section "tracepoint/syscalls/sys_enter_kill" !dbg !22 {
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !37, metadata !DIExpression()), !dbg !189
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !46, metadata !DIExpression()), !dbg !190
  call void @llvm.dbg.declare(metadata [2 x i8]* undef, metadata !47, metadata !DIExpression()), !dbg !191
  %2 = alloca %struct.OpResult, align 8
  %3 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.syscalls_enter_kill_args* %0, metadata !36, metadata !DIExpression()), !dbg !192
  %4 = bitcast %struct.OpResult* %2 to i8*, !dbg !193
  call void @llvm.lifetime.start.p0i8(i64 184, i8* nonnull %4) #6, !dbg !193
  call void @llvm.dbg.declare(metadata %struct.OpResult* %2, metadata !48, metadata !DIExpression()), !dbg !194
  %5 = bitcast i32* %3 to i8*, !dbg !195
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #6, !dbg !195
  call void @llvm.dbg.value(metadata i32 0, metadata !92, metadata !DIExpression()), !dbg !192
  store i32 0, i32* %3, align 4, !dbg !196, !tbaa !197
  call void @llvm.dbg.value(metadata i32* %3, metadata !92, metadata !DIExpression(DW_OP_deref)), !dbg !192
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon* @string_pool_map to i8*), i8* noundef nonnull %5) #6, !dbg !201
  call void @llvm.dbg.value(metadata i8* %6, metadata !93, metadata !DIExpression()), !dbg !192
  %7 = icmp eq i8* %6, null, !dbg !202
  br i1 %7, label %8, label %12, !dbg !204

8:                                                ; preds = %1
  %9 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %9, i8 0, i64 24, i1 false), !dbg !205
  %10 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !207
  store i32 1, i32* %10, align 8, !dbg !207, !tbaa.struct !208
  %11 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !207
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %11, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str, i64 0, i64 0), i64 150, i1 false), !dbg !207, !tbaa.struct !210
  br label %73, !dbg !211

12:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32* %3, metadata !92, metadata !DIExpression(DW_OP_deref)), !dbg !192
  %13 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.0* @string_pool_index_map to i8*), i8* noundef nonnull %5) #6, !dbg !212
  call void @llvm.dbg.value(metadata i8* %13, metadata !98, metadata !DIExpression()), !dbg !192
  %14 = icmp eq i8* %13, null, !dbg !213
  br i1 %14, label %15, label %19, !dbg !215

15:                                               ; preds = %12
  %16 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %16, i8 0, i64 24, i1 false), !dbg !216
  %17 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !218
  store i32 1, i32* %17, align 8, !dbg !218, !tbaa.struct !208
  %18 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !218
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %18, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.1, i64 0, i64 0), i64 150, i1 false), !dbg !218, !tbaa.struct !210
  br label %73, !dbg !219

19:                                               ; preds = %12
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(3) %6, i8* noundef nonnull align 1 dereferenceable(3) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i64 0, i64 0), i64 3, i1 false), !dbg !220
  %20 = getelementptr inbounds i8, i8* %6, i64 3, !dbg !221
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(5) %20, i8* noundef nonnull align 1 dereferenceable(5) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3, i64 0, i64 0), i64 5, i1 false), !dbg !222
  %21 = getelementptr inbounds i8, i8* %6, i64 8, !dbg !223
  %22 = bitcast i8* %21 to i32*, !dbg !224
  store i32 1702195828, i32* %22, align 1, !dbg !224
  call void @llvm.dbg.value(metadata i32* %3, metadata !92, metadata !DIExpression(DW_OP_deref)), !dbg !192
  %23 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.1* @heap_map to i8*), i8* noundef nonnull %5) #6, !dbg !225
  %24 = bitcast i8* %23 to [100 x %struct.Generic]*, !dbg !225
  call void @llvm.dbg.value(metadata [100 x %struct.Generic]* %24, metadata !100, metadata !DIExpression()), !dbg !192
  %25 = icmp eq i8* %23, null, !dbg !226
  br i1 %25, label %26, label %30, !dbg !228

26:                                               ; preds = %19
  %27 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %27, i8 0, i64 24, i1 false), !dbg !229
  %28 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !231
  store i32 1, i32* %28, align 8, !dbg !231, !tbaa.struct !208
  %29 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !231
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %29, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.5, i64 0, i64 0), i64 150, i1 false), !dbg !231, !tbaa.struct !210
  br label %73, !dbg !232

30:                                               ; preds = %19
  call void @llvm.dbg.value(metadata i32* %3, metadata !92, metadata !DIExpression(DW_OP_deref)), !dbg !192
  %31 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* noundef bitcast (%struct.anon.2* @heap_index_map to i8*), i8* noundef nonnull %5) #6, !dbg !233
  %32 = bitcast i8* %31 to i32*, !dbg !233
  call void @llvm.dbg.value(metadata i32* %32, metadata !105, metadata !DIExpression()), !dbg !192
  %33 = icmp eq i8* %31, null, !dbg !234
  br i1 %33, label %34, label %38, !dbg !236

34:                                               ; preds = %30
  %35 = bitcast %struct.OpResult* %2 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(24) %35, i8 0, i64 24, i1 false), !dbg !237
  %36 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 1, !dbg !239
  store i32 1, i32* %36, align 8, !dbg !239, !tbaa.struct !208
  %37 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !239
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 4 dereferenceable(150) %37, i8* noundef nonnull align 4 dereferenceable(150) getelementptr inbounds ([150 x i8], [150 x i8]* @.str.6, i64 0, i64 0), i64 150, i1 false), !dbg !239, !tbaa.struct !210
  br label %73, !dbg !240

38:                                               ; preds = %30
  call void @llvm.dbg.value(metadata i32 9, metadata !106, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !192
  %39 = load i32, i32* %32, align 4, !dbg !241, !tbaa !197
  %40 = add i32 %39, 1, !dbg !241
  call void @llvm.dbg.value(metadata i32 %39, metadata !106, metadata !DIExpression(DW_OP_LLVM_fragment, 64, 32)), !dbg !192
  %41 = add i32 %39, 2, !dbg !242
  call void @llvm.dbg.value(metadata i32 %40, metadata !106, metadata !DIExpression(DW_OP_LLVM_fragment, 96, 32)), !dbg !192
  %42 = add i32 %39, 3, !dbg !243
  call void @llvm.dbg.value(metadata i32 %41, metadata !106, metadata !DIExpression(DW_OP_LLVM_fragment, 128, 32)), !dbg !192
  %43 = add i32 %39, 4, !dbg !244
  store i32 %43, i32* %32, align 4, !dbg !244, !tbaa !197
  call void @llvm.dbg.value(metadata i32 %42, metadata !106, metadata !DIExpression(DW_OP_LLVM_fragment, 160, 32)), !dbg !192
  call void @llvm.dbg.value(metadata i32 %42, metadata !107, metadata !DIExpression()), !dbg !192
  %44 = icmp ult i32 %40, 100, !dbg !245
  br i1 %44, label %45, label %53, !dbg !247

45:                                               ; preds = %38
  %46 = zext i32 %40 to i64, !dbg !248
  %47 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 1, !dbg !250
  %48 = load i64, i64* %47, align 8, !dbg !250, !tbaa !251
  %49 = trunc i64 %48 to i32, !dbg !255
  %50 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %46, i32 0, !dbg !256
  store i32 2, i32* %50, align 8, !dbg !256, !tbaa.struct !257
  %51 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %46, i32 1, !dbg !256
  %52 = bitcast %union.ElixirValue* %51 to i32*, !dbg !256
  store i32 %49, i32* %52, align 8, !dbg !256, !tbaa.struct !260
  br label %53, !dbg !261

53:                                               ; preds = %45, %38
  %54 = icmp ult i32 %41, 100, !dbg !262
  br i1 %54, label %55, label %63, !dbg !264

55:                                               ; preds = %53
  %56 = zext i32 %41 to i64, !dbg !265
  %57 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 2, !dbg !267
  %58 = load i64, i64* %57, align 8, !dbg !267, !tbaa !268
  %59 = trunc i64 %58 to i32, !dbg !269
  %60 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %56, i32 0, !dbg !270
  store i32 2, i32* %60, align 8, !dbg !270, !tbaa.struct !257
  %61 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %56, i32 1, !dbg !270
  %62 = bitcast %union.ElixirValue* %61 to i32*, !dbg !270
  store i32 %59, i32* %62, align 8, !dbg !270, !tbaa.struct !260
  br label %63, !dbg !271

63:                                               ; preds = %55, %53
  %64 = icmp ult i32 %42, 100, !dbg !272
  br i1 %64, label %65, label %76, !dbg !274

65:                                               ; preds = %63
  %66 = zext i32 %42 to i64, !dbg !275
  %67 = getelementptr inbounds %struct.syscalls_enter_kill_args, %struct.syscalls_enter_kill_args* %0, i64 0, i32 3, !dbg !277
  %68 = load i64, i64* %67, align 8, !dbg !277, !tbaa !278
  %69 = trunc i64 %68 to i32, !dbg !279
  %70 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %66, i32 0, !dbg !280
  store i32 2, i32* %70, align 8, !dbg !280, !tbaa.struct !257
  %71 = getelementptr inbounds [100 x %struct.Generic], [100 x %struct.Generic]* %24, i64 0, i64 %66, i32 1, !dbg !280
  %72 = bitcast %union.ElixirValue* %71 to i32*, !dbg !280
  store i32 %69, i32* %72, align 8, !dbg !280, !tbaa.struct !260
  br label %76, !dbg !281

73:                                               ; preds = %34, %26, %15, %8
  call void @llvm.dbg.label(metadata !109), !dbg !282
  %74 = getelementptr inbounds %struct.OpResult, %struct.OpResult* %2, i64 0, i32 2, i64 0, !dbg !283
  %75 = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @main_func.____fmt, i64 0, i64 0), i32 noundef 7, i8* noundef nonnull %74) #6, !dbg !283
  br label %76, !dbg !285

76:                                               ; preds = %65, %63, %73
  %77 = phi i32 [ 0, %73 ], [ 1, %63 ], [ 1, %65 ], !dbg !192
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #6, !dbg !286
  call void @llvm.lifetime.end.p0i8(i64 184, i8* nonnull %4) #6, !dbg !286
  ret i32 %77, !dbg !286
}

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: mustprogress nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #5

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #4 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #5 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!184, !185, !186, !187}
!llvm.ident = !{!188}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !6, line: 164, type: !181, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 14.0.6", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !19, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "src/HoneyTest.JustCompiles.bpf.c", directory: "/run/media/kaelsa/1tera/Kael media/KPrograms/GitHub/honey-potion/test", checksumkind: CSK_MD5, checksum: "a3fae184f00f58d95098cb5a70cf6862")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Type", file: !6, line: 47, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "./src/HoneyTest.JustCompiles.bpf.c", directory: "/run/media/kaelsa/1tera/Kael media/KPrograms/GitHub/honey-potion/test", checksumkind: CSK_MD5, checksum: "a3fae184f00f58d95098cb5a70cf6862")
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
!19 = !{!0, !20, !114, !136, !144, !156, !164, !173}
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "____fmt", scope: !22, file: !6, line: 624, type: !110, isLocal: true, isDefinition: true)
!22 = distinct !DISubprogram(name: "main_func", scope: !6, file: !6, line: 552, type: !23, scopeLine: 552, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !35)
!23 = !DISubroutineType(types: !24)
!24 = !{!25, !26}
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_kill_args", file: !6, line: 115, size: 256, elements: !28)
!28 = !{!29, !31, !33, !34}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !27, file: !6, line: 121, baseType: !30, size: 64)
!30 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "syscall_nr", scope: !27, file: !6, line: 123, baseType: !32, size: 64, offset: 64)
!32 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !27, file: !6, line: 124, baseType: !32, size: 64, offset: 128)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "sig", scope: !27, file: !6, line: 125, baseType: !32, size: 64, offset: 192)
!35 = !{!36, !37, !46, !47, !48, !92, !93, !98, !100, !105, !106, !107, !108, !109}
!36 = !DILocalVariable(name: "ctx_arg", arg: 1, scope: !22, file: !6, line: 552, type: !26)
!37 = !DILocalVariable(name: "str_param1", scope: !22, file: !6, line: 554, type: !38)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "StrFormatSpec", file: !6, line: 113, baseType: !39)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "StrFormatSpec", file: !6, line: 110, size: 16, elements: !40)
!40 = !{!41}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "spec", scope: !39, file: !6, line: 112, baseType: !42, size: 16)
!42 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 16, elements: !44)
!43 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!44 = !{!45}
!45 = !DISubrange(count: 2)
!46 = !DILocalVariable(name: "str_param2", scope: !22, file: !6, line: 555, type: !38)
!47 = !DILocalVariable(name: "str_param3", scope: !22, file: !6, line: 556, type: !38)
!48 = !DILocalVariable(name: "op_result", scope: !22, file: !6, line: 558, type: !49)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "OpResult", file: !6, line: 108, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "OpResult", file: !6, line: 103, size: 1472, elements: !51)
!51 = !{!52, !87, !88}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "result_var", scope: !50, file: !6, line: 105, baseType: !53, size: 192)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "Generic", file: !6, line: 101, baseType: !54)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Generic", file: !6, line: 97, size: 192, elements: !55)
!55 = !{!56, !58}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !54, file: !6, line: 99, baseType: !57, size: 32)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "Type", file: !6, line: 59, baseType: !5)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !54, file: !6, line: 100, baseType: !59, size: 128, offset: 64)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "ElixirValue", file: !6, line: 95, baseType: !60)
!60 = distinct !DICompositeType(tag: DW_TAG_union_type, name: "ElixirValue", file: !6, line: 87, size: 128, elements: !61)
!61 = !{!62, !63, !64, !66, !73, !79}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "integer", scope: !60, file: !6, line: 89, baseType: !25, size: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "u_integer", scope: !60, file: !6, line: 90, baseType: !7, size: 32)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "double_precision", scope: !60, file: !6, line: 91, baseType: !65, size: 64)
!65 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "tuple", scope: !60, file: !6, line: 92, baseType: !67, size: 96)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "Tuple", file: !6, line: 66, baseType: !68)
!68 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "Tuple", file: !6, line: 61, size: 96, elements: !69)
!69 = !{!70, !71, !72}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "idx", scope: !68, file: !6, line: 63, baseType: !25, size: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "value_idx", scope: !68, file: !6, line: 64, baseType: !25, size: 32, offset: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "nextElement_idx", scope: !68, file: !6, line: 65, baseType: !25, size: 32, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "string", scope: !60, file: !6, line: 93, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "String", file: !6, line: 72, baseType: !75)
!75 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "String", file: !6, line: 68, size: 64, elements: !76)
!76 = !{!77, !78}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !75, file: !6, line: 70, baseType: !25, size: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !75, file: !6, line: 71, baseType: !25, size: 32, offset: 32)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "syscalls_enter_kill_args", scope: !60, file: !6, line: 94, baseType: !80, size: 128)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "struct_Syscalls_enter_kill_args", file: !6, line: 85, baseType: !81)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "struct_Syscalls_enter_kill_args", file: !6, line: 79, size: 128, elements: !82)
!82 = !{!83, !84, !85, !86}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pad", scope: !81, file: !6, line: 81, baseType: !7, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "pos_syscall_nr", scope: !81, file: !6, line: 82, baseType: !7, size: 32, offset: 32)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "pos_pid", scope: !81, file: !6, line: 83, baseType: !7, size: 32, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "pos_sig", scope: !81, file: !6, line: 84, baseType: !7, size: 32, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "exception", scope: !50, file: !6, line: 106, baseType: !25, size: 32, offset: 192)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "exception_msg", scope: !50, file: !6, line: 107, baseType: !89, size: 1200, offset: 224)
!89 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 1200, elements: !90)
!90 = !{!91}
!91 = !DISubrange(count: 150)
!92 = !DILocalVariable(name: "zero", scope: !22, file: !6, line: 560, type: !25)
!93 = !DILocalVariable(name: "string_pool", scope: !22, file: !6, line: 561, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 4000, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 500)
!98 = !DILocalVariable(name: "string_pool_index", scope: !22, file: !6, line: 568, type: !99)
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!100 = !DILocalVariable(name: "heap", scope: !22, file: !6, line: 579, type: !101)
!101 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 19200, elements: !103)
!103 = !{!104}
!104 = !DISubrange(count: 100)
!105 = !DILocalVariable(name: "heap_index", scope: !22, file: !6, line: 586, type: !99)
!106 = !DILocalVariable(name: "ctx0nil", scope: !22, file: !6, line: 594, type: !53)
!107 = !DILocalVariable(name: "last_index", scope: !22, file: !6, line: 595, type: !7)
!108 = !DILocalVariable(name: "helper_var_905", scope: !22, file: !6, line: 614, type: !53)
!109 = !DILabel(scope: !22, name: "CATCH", file: !6, line: 623)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 56, elements: !112)
!111 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !43)
!112 = !{!113}
!113 = !DISubrange(count: 7)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(name: "string_pool_map", scope: !2, file: !6, line: 136, type: !116, isLocal: false, isDefinition: true)
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 130, size: 256, elements: !117)
!117 = !{!118, !123, !128, !133}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !116, file: !6, line: 132, baseType: !119, size: 64)
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 192, elements: !121)
!121 = !{!122}
!122 = !DISubrange(count: 6)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !116, file: !6, line: 133, baseType: !124, size: 64, offset: 64)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 32, elements: !126)
!126 = !{!127}
!127 = !DISubrange(count: 1)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !116, file: !6, line: 134, baseType: !129, size: 64, offset: 128)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 128, elements: !131)
!131 = !{!132}
!132 = !DISubrange(count: 4)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !116, file: !6, line: 135, baseType: !134, size: 64, offset: 192)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 16000, elements: !96)
!136 = !DIGlobalVariableExpression(var: !137, expr: !DIExpression())
!137 = distinct !DIGlobalVariable(name: "string_pool_index_map", scope: !2, file: !6, line: 144, type: !138, isLocal: false, isDefinition: true)
!138 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 138, size: 256, elements: !139)
!139 = !{!140, !141, !142, !143}
!140 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !138, file: !6, line: 140, baseType: !119, size: 64)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !138, file: !6, line: 141, baseType: !124, size: 64, offset: 64)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !138, file: !6, line: 142, baseType: !129, size: 64, offset: 128)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !138, file: !6, line: 143, baseType: !129, size: 64, offset: 192)
!144 = !DIGlobalVariableExpression(var: !145, expr: !DIExpression())
!145 = distinct !DIGlobalVariable(name: "heap_map", scope: !2, file: !6, line: 153, type: !146, isLocal: false, isDefinition: true)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 147, size: 256, elements: !147)
!147 = !{!148, !149, !150, !151}
!148 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !146, file: !6, line: 149, baseType: !119, size: 64)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !146, file: !6, line: 150, baseType: !124, size: 64, offset: 64)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !146, file: !6, line: 151, baseType: !129, size: 64, offset: 128)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !146, file: !6, line: 152, baseType: !152, size: 64, offset: 192)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !153, size: 64)
!153 = !DICompositeType(tag: DW_TAG_array_type, baseType: !25, size: 76800, elements: !154)
!154 = !{!155}
!155 = !DISubrange(count: 2400)
!156 = !DIGlobalVariableExpression(var: !157, expr: !DIExpression())
!157 = distinct !DIGlobalVariable(name: "heap_index_map", scope: !2, file: !6, line: 161, type: !158, isLocal: false, isDefinition: true)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !6, line: 155, size: 256, elements: !159)
!159 = !{!160, !161, !162, !163}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !158, file: !6, line: 157, baseType: !119, size: 64)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !158, file: !6, line: 158, baseType: !124, size: 64, offset: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !158, file: !6, line: 159, baseType: !129, size: 64, offset: 128)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !158, file: !6, line: 160, baseType: !129, size: 64, offset: 192)
!164 = !DIGlobalVariableExpression(var: !165, expr: !DIExpression())
!165 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !166, line: 51, type: !167, isLocal: true, isDefinition: true)
!166 = !DIFile(filename: "benchmarks/libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/run/media/kaelsa/1tera/Kael media/KPrograms/GitHub/honey-potion", checksumkind: CSK_MD5, checksum: "ad8ff3755106b533b446159c410c596d")
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!168 = !DISubroutineType(types: !169)
!169 = !{!170, !170, !171}
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!173 = !DIGlobalVariableExpression(var: !174, expr: !DIExpression())
!174 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !166, line: 172, type: !175, isLocal: true, isDefinition: true)
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !176, size: 64)
!176 = !DISubroutineType(types: !177)
!177 = !{!32, !178, !179, null}
!178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!179 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !180, line: 27, baseType: !7)
!180 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!181 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 40, elements: !182)
!182 = !{!183}
!183 = !DISubrange(count: 5)
!184 = !{i32 7, !"Dwarf Version", i32 5}
!185 = !{i32 2, !"Debug Info Version", i32 3}
!186 = !{i32 1, !"wchar_size", i32 4}
!187 = !{i32 7, !"frame-pointer", i32 2}
!188 = !{!"clang version 14.0.6"}
!189 = !DILocation(line: 554, column: 15, scope: !22)
!190 = !DILocation(line: 555, column: 15, scope: !22)
!191 = !DILocation(line: 556, column: 15, scope: !22)
!192 = !DILocation(line: 0, scope: !22)
!193 = !DILocation(line: 558, column: 1, scope: !22)
!194 = !DILocation(line: 558, column: 10, scope: !22)
!195 = !DILocation(line: 560, column: 1, scope: !22)
!196 = !DILocation(line: 560, column: 5, scope: !22)
!197 = !{!198, !198, i64 0}
!198 = !{!"int", !199, i64 0}
!199 = !{!"omnipotent char", !200, i64 0}
!200 = !{!"Simple C/C++ TBAA"}
!201 = !DILocation(line: 561, column: 40, scope: !22)
!202 = !DILocation(line: 562, column: 6, scope: !203)
!203 = distinct !DILexicalBlock(scope: !22, file: !6, line: 562, column: 5)
!204 = !DILocation(line: 562, column: 5, scope: !22)
!205 = !DILocation(line: 564, column: 25, scope: !206)
!206 = distinct !DILexicalBlock(scope: !203, file: !6, line: 563, column: 1)
!207 = !DILocation(line: 564, column: 15, scope: !206)
!208 = !{i64 0, i64 4, !197, i64 4, i64 150, !209}
!209 = !{!199, !199, i64 0}
!210 = !{i64 0, i64 150, !209}
!211 = !DILocation(line: 565, column: 3, scope: !206)
!212 = !DILocation(line: 568, column: 31, scope: !22)
!213 = !DILocation(line: 569, column: 6, scope: !214)
!214 = distinct !DILexicalBlock(scope: !22, file: !6, line: 569, column: 5)
!215 = !DILocation(line: 569, column: 5, scope: !22)
!216 = !DILocation(line: 571, column: 25, scope: !217)
!217 = distinct !DILexicalBlock(scope: !214, file: !6, line: 570, column: 1)
!218 = !DILocation(line: 571, column: 15, scope: !217)
!219 = !DILocation(line: 572, column: 3, scope: !217)
!220 = !DILocation(line: 575, column: 1, scope: !22)
!221 = !DILocation(line: 576, column: 31, scope: !22)
!222 = !DILocation(line: 576, column: 1, scope: !22)
!223 = !DILocation(line: 577, column: 35, scope: !22)
!224 = !DILocation(line: 577, column: 1, scope: !22)
!225 = !DILocation(line: 579, column: 29, scope: !22)
!226 = !DILocation(line: 580, column: 6, scope: !227)
!227 = distinct !DILexicalBlock(scope: !22, file: !6, line: 580, column: 5)
!228 = !DILocation(line: 580, column: 5, scope: !22)
!229 = !DILocation(line: 582, column: 25, scope: !230)
!230 = distinct !DILexicalBlock(scope: !227, file: !6, line: 581, column: 1)
!231 = !DILocation(line: 582, column: 15, scope: !230)
!232 = !DILocation(line: 583, column: 3, scope: !230)
!233 = !DILocation(line: 586, column: 24, scope: !22)
!234 = !DILocation(line: 587, column: 6, scope: !235)
!235 = distinct !DILexicalBlock(scope: !22, file: !6, line: 587, column: 5)
!236 = !DILocation(line: 587, column: 5, scope: !22)
!237 = !DILocation(line: 589, column: 25, scope: !238)
!238 = distinct !DILexicalBlock(scope: !235, file: !6, line: 588, column: 1)
!239 = !DILocation(line: 589, column: 15, scope: !238)
!240 = !DILocation(line: 590, column: 3, scope: !238)
!241 = !DILocation(line: 594, column: 106, scope: !22)
!242 = !DILocation(line: 594, column: 123, scope: !22)
!243 = !DILocation(line: 594, column: 140, scope: !22)
!244 = !DILocation(line: 594, column: 157, scope: !22)
!245 = !DILocation(line: 600, column: 59, scope: !246)
!246 = distinct !DILexicalBlock(scope: !22, file: !6, line: 600, column: 5)
!247 = !DILocation(line: 600, column: 5, scope: !22)
!248 = !DILocation(line: 602, column: 3, scope: !249)
!249 = distinct !DILexicalBlock(scope: !246, file: !6, line: 601, column: 1)
!250 = !DILocation(line: 602, column: 121, scope: !249)
!251 = !{!252, !254, i64 8}
!252 = !{!"syscalls_enter_kill_args", !253, i64 0, !254, i64 8, !254, i64 16, !254, i64 24}
!253 = !{!"long long", !199, i64 0}
!254 = !{!"long", !199, i64 0}
!255 = !DILocation(line: 602, column: 112, scope: !249)
!256 = !DILocation(line: 602, column: 68, scope: !249)
!257 = !{i64 0, i64 4, !209, i64 8, i64 4, !197, i64 8, i64 4, !197, i64 8, i64 8, !258, i64 8, i64 4, !197, i64 12, i64 4, !197, i64 16, i64 4, !197, i64 8, i64 4, !197, i64 12, i64 4, !197, i64 8, i64 4, !197, i64 12, i64 4, !197, i64 16, i64 4, !197, i64 20, i64 4, !197}
!258 = !{!259, !259, i64 0}
!259 = !{!"double", !199, i64 0}
!260 = !{i64 0, i64 4, !197, i64 0, i64 4, !197, i64 0, i64 8, !258, i64 0, i64 4, !197, i64 4, i64 4, !197, i64 8, i64 4, !197, i64 0, i64 4, !197, i64 4, i64 4, !197, i64 0, i64 4, !197, i64 4, i64 4, !197, i64 8, i64 4, !197, i64 12, i64 4, !197}
!261 = !DILocation(line: 603, column: 1, scope: !249)
!262 = !DILocation(line: 604, column: 52, scope: !263)
!263 = distinct !DILexicalBlock(scope: !22, file: !6, line: 604, column: 5)
!264 = !DILocation(line: 604, column: 5, scope: !22)
!265 = !DILocation(line: 606, column: 3, scope: !266)
!266 = distinct !DILexicalBlock(scope: !263, file: !6, line: 605, column: 1)
!267 = !DILocation(line: 606, column: 114, scope: !266)
!268 = !{!252, !254, i64 16}
!269 = !DILocation(line: 606, column: 105, scope: !266)
!270 = !DILocation(line: 606, column: 61, scope: !266)
!271 = !DILocation(line: 607, column: 1, scope: !266)
!272 = !DILocation(line: 608, column: 52, scope: !273)
!273 = distinct !DILexicalBlock(scope: !22, file: !6, line: 608, column: 5)
!274 = !DILocation(line: 608, column: 5, scope: !22)
!275 = !DILocation(line: 610, column: 3, scope: !276)
!276 = distinct !DILexicalBlock(scope: !273, file: !6, line: 609, column: 1)
!277 = !DILocation(line: 610, column: 114, scope: !276)
!278 = !{!252, !254, i64 24}
!279 = !DILocation(line: 610, column: 105, scope: !276)
!280 = !DILocation(line: 610, column: 61, scope: !276)
!281 = !DILocation(line: 611, column: 1, scope: !276)
!282 = !DILocation(line: 623, column: 1, scope: !22)
!283 = !DILocation(line: 624, column: 3, scope: !284)
!284 = distinct !DILexicalBlock(scope: !22, file: !6, line: 624, column: 3)
!285 = !DILocation(line: 625, column: 3, scope: !22)
!286 = !DILocation(line: 627, column: 1, scope: !22)
