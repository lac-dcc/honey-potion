; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.syscalls_enter_kill_args = type { i64, i64, i64, i64 }

@map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !21
@_version = dso_local global i32 393984, section "version", align 4, !dbg !27
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @_version, ptr @map, ptr @sysEnterKill], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @sysEnterKill(ptr nocapture noundef readonly %0) #0 section "tracepoint/syscalls/sys_enter_kill" !dbg !65 {
  %2 = alloca i64, align 8
  %3 = alloca i32, align 4
  call void @llvm.dbg.value(metadata ptr %0, metadata !77, metadata !DIExpression()), !dbg !80
  %4 = getelementptr inbounds %struct.syscalls_enter_kill_args, ptr %0, i64 0, i32 3, !dbg !81
  %5 = load i64, ptr %4, align 8, !dbg !81, !tbaa !83
  %6 = icmp eq i64 %5, 9, !dbg !89
  br i1 %6, label %7, label %12, !dbg !90

7:                                                ; preds = %1
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #3, !dbg !91
  %8 = getelementptr inbounds %struct.syscalls_enter_kill_args, ptr %0, i64 0, i32 2, !dbg !92
  %9 = load i64, ptr %8, align 8, !dbg !92, !tbaa !93
  %10 = tail call i64 @llvm.abs.i64(i64 %9, i1 true), !dbg !94
  call void @llvm.dbg.value(metadata i64 %10, metadata !78, metadata !DIExpression()), !dbg !80
  store i64 %10, ptr %2, align 8, !dbg !95, !tbaa !96
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %3) #3, !dbg !97
  call void @llvm.dbg.value(metadata i32 1, metadata !79, metadata !DIExpression()), !dbg !80
  store i32 1, ptr %3, align 4, !dbg !98, !tbaa !99
  call void @llvm.dbg.value(metadata ptr %2, metadata !78, metadata !DIExpression(DW_OP_deref)), !dbg !80
  call void @llvm.dbg.value(metadata ptr %3, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !80
  %11 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %2, ptr noundef nonnull %3, i64 noundef 1) #3, !dbg !101
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %3) #3, !dbg !102
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #3, !dbg !102
  br label %12

12:                                               ; preds = %1, %7
  ret i32 0, !dbg !102
}

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare i64 @llvm.abs.i64(i64, i1 immarg) #2

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!60, !61, !62, !63}
!llvm.ident = !{!64}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !3, line: 13, type: !43, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !20, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/forcekill", checksumkind: CSK_MD5, checksum: "f4a63692a2c612a6890e8f991a4aa230")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 6130, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "b90a69f1fa9b9ccf0c666897a6f64ece")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2)
!12 = !DIEnumerator(name: "XDP_TX", value: 3)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 1224, baseType: !7, size: 32, elements: !15)
!15 = !{!16, !17, !18, !19}
!16 = !DIEnumerator(name: "BPF_ANY", value: 0)
!17 = !DIEnumerator(name: "BPF_NOEXIST", value: 1)
!18 = !DIEnumerator(name: "BPF_EXIST", value: 2)
!19 = !DIEnumerator(name: "BPF_F_LOCK", value: 4)
!20 = !{!21, !27, !0, !31}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 41, type: !23, isLocal: false, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "_version", scope: !2, file: !3, line: 42, type: !29, isLocal: false, isDefinition: true)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !30, line: 27, baseType: !7)
!30 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !33, line: 73, type: !34, isLocal: true, isDefinition: true)
!33 = !DIFile(filename: "../../libs/libbpf/src/root/usr/include/bpf/bpf_helper_defs.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/forcekill", checksumkind: CSK_MD5, checksum: "ad8ff3755106b533b446159c410c596d")
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DISubroutineType(types: !36)
!36 = !{!37, !38, !39, !39, !41}
!37 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !30, line: 31, baseType: !42)
!42 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 8, size: 256, elements: !44)
!44 = !{!45, !51, !56, !58}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !43, file: !3, line: 9, baseType: !46, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 32, elements: !49)
!48 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!49 = !{!50}
!50 = !DISubrange(count: 1)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !43, file: !3, line: 10, baseType: !52, size: 64, offset: 64)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !48, size: 2048, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 64)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !43, file: !3, line: 11, baseType: !57, size: 64, offset: 128)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !43, file: !3, line: 12, baseType: !59, size: 64, offset: 192)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!60 = !{i32 7, !"Dwarf Version", i32 5}
!61 = !{i32 2, !"Debug Info Version", i32 3}
!62 = !{i32 1, !"wchar_size", i32 4}
!63 = !{i32 7, !"frame-pointer", i32 2}
!64 = !{!"clang version 15.0.7"}
!65 = distinct !DISubprogram(name: "sysEnterKill", scope: !3, file: !3, line: 28, type: !66, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !76)
!66 = !DISubroutineType(types: !67)
!67 = !{!48, !68}
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_kill_args", file: !3, line: 15, size: 256, elements: !70)
!70 = !{!71, !73, !74, !75}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "pad", scope: !69, file: !3, line: 20, baseType: !72, size: 64)
!72 = !DIBasicType(name: "long long", size: 64, encoding: DW_ATE_signed)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "syscall_nr", scope: !69, file: !3, line: 22, baseType: !37, size: 64, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !69, file: !3, line: 23, baseType: !37, size: 64, offset: 128)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "sig", scope: !69, file: !3, line: 24, baseType: !37, size: 64, offset: 192)
!76 = !{!77, !78, !79}
!77 = !DILocalVariable(name: "ctx", arg: 1, scope: !65, file: !3, line: 28, type: !68)
!78 = !DILocalVariable(name: "key", scope: !65, file: !3, line: 32, type: !37)
!79 = !DILocalVariable(name: "val", scope: !65, file: !3, line: 33, type: !48)
!80 = !DILocation(line: 0, scope: !65)
!81 = !DILocation(line: 29, column: 12, scope: !82)
!82 = distinct !DILexicalBlock(scope: !65, file: !3, line: 29, column: 7)
!83 = !{!84, !88, i64 24}
!84 = !{!"syscalls_enter_kill_args", !85, i64 0, !88, i64 8, !88, i64 16, !88, i64 24}
!85 = !{!"long long", !86, i64 0}
!86 = !{!"omnipotent char", !87, i64 0}
!87 = !{!"Simple C/C++ TBAA"}
!88 = !{!"long", !86, i64 0}
!89 = !DILocation(line: 29, column: 16, scope: !82)
!90 = !DILocation(line: 29, column: 7, scope: !65)
!91 = !DILocation(line: 32, column: 3, scope: !65)
!92 = !DILocation(line: 32, column: 24, scope: !65)
!93 = !{!84, !88, i64 16}
!94 = !DILocation(line: 32, column: 14, scope: !65)
!95 = !DILocation(line: 32, column: 8, scope: !65)
!96 = !{!88, !88, i64 0}
!97 = !DILocation(line: 33, column: 3, scope: !65)
!98 = !DILocation(line: 33, column: 7, scope: !65)
!99 = !{!100, !100, i64 0}
!100 = !{!"int", !86, i64 0}
!101 = !DILocation(line: 35, column: 3, scope: !65)
!102 = !DILocation(line: 38, column: 1, scope: !65)
