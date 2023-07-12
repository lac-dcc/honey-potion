; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.syscallNames = type { i64, [15 x i8] }
%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.syscalls_enter_args = type { i16, i8, i8, i32, i64, [6 x i64] }

@SYSCALLSNAMES = dso_local local_unnamed_addr global [3 x %struct.syscallNames] [%struct.syscallNames { i64 62, [15 x i8] c"enter_kill\00\00\00\00\00" }, %struct.syscallNames { i64 83, [15 x i8] c"enter_mkdir\00\00\00\00" }, %struct.syscallNames { i64 318, [15 x i8] c"enter_getrandom" }], align 8, !dbg !0
@map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !27
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !17
@_version = dso_local global i32 393984, section "version", align 4, !dbg !23
@llvm.compiler.used = appending global [4 x ptr] [ptr @_license, ptr @_version, ptr @countSyscalls, ptr @map], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @countSyscalls(ptr nocapture noundef readonly %0) #0 section "tracepoint/raw_syscalls/sys_enter" !dbg !76 {
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata ptr %0, metadata !95, metadata !DIExpression()), !dbg !102
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #3, !dbg !103
  %4 = getelementptr inbounds %struct.syscalls_enter_args, ptr %0, i64 0, i32 4, !dbg !104
  %5 = load i64, ptr %4, align 8, !dbg !104, !tbaa !105
  call void @llvm.dbg.value(metadata i64 %5, metadata !96, metadata !DIExpression()), !dbg !102
  store i64 %5, ptr %2, align 8, !dbg !112, !tbaa !113
  call void @llvm.dbg.value(metadata i32 0, metadata !97, metadata !DIExpression()), !dbg !102
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %3) #3, !dbg !114
  call void @llvm.dbg.value(metadata i64 0, metadata !98, metadata !DIExpression()), !dbg !102
  store i64 0, ptr %3, align 8, !dbg !115, !tbaa !113
  call void @llvm.dbg.value(metadata i32 0, metadata !99, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 0, metadata !99, metadata !DIExpression()), !dbg !116
  %6 = load i64, ptr @SYSCALLSNAMES, align 8, !dbg !117, !tbaa !121
  call void @llvm.dbg.value(metadata i64 %5, metadata !96, metadata !DIExpression()), !dbg !102
  %7 = icmp eq i64 %6, %5, !dbg !123
  call void @llvm.dbg.value(metadata i64 0, metadata !99, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !116
  %8 = load i64, ptr getelementptr inbounds ([3 x %struct.syscallNames], ptr @SYSCALLSNAMES, i64 0, i64 1), align 8
  %9 = icmp eq i64 %8, %5
  %10 = select i1 %7, i1 true, i1 %9, !dbg !124
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 0, metadata !99, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !116
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 %5, metadata !96, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !116
  %11 = load i64, ptr getelementptr inbounds ([3 x %struct.syscallNames], ptr @SYSCALLSNAMES, i64 0, i64 2), align 8
  %12 = icmp eq i64 %11, %5
  %13 = select i1 %10, i1 true, i1 %12, !dbg !124
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 1, metadata !99, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !116
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 %5, metadata !96, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata i64 2, metadata !99, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !116
  br i1 %13, label %14, label %21, !dbg !124

14:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i32 undef, metadata !97, metadata !DIExpression()), !dbg !102
  call void @llvm.dbg.value(metadata ptr %2, metadata !96, metadata !DIExpression(DW_OP_deref)), !dbg !102
  %15 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %2) #3, !dbg !125
  call void @llvm.dbg.value(metadata ptr %15, metadata !101, metadata !DIExpression()), !dbg !102
  %16 = icmp eq ptr %15, null, !dbg !126
  %17 = select i1 %16, ptr %3, ptr %15, !dbg !128
  call void @llvm.dbg.value(metadata ptr %17, metadata !101, metadata !DIExpression()), !dbg !102
  %18 = load i64, ptr %17, align 8, !dbg !129, !tbaa !113
  %19 = add nsw i64 %18, 1, !dbg !130
  store i64 %19, ptr %17, align 8, !dbg !131, !tbaa !113
  %20 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %2, ptr noundef nonnull %17, i64 noundef 0) #3, !dbg !132
  br label %21

21:                                               ; preds = %1, %14
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %3) #3, !dbg !133
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #3, !dbg !133
  ret i32 0, !dbg !133
}

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #2 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!71, !72, !73, !74}
!llvm.ident = !{!75}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "SYSCALLSNAMES", scope: !2, file: !60, line: 10, type: !61, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !16, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/countsyscalls", checksumkind: CSK_MD5, checksum: "31200da3f072c5608dfe6d60d45bd264")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 1224, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/linux/bpf.h", directory: "", checksumkind: CSK_MD5, checksum: "b90a69f1fa9b9ccf0c666897a6f64ece")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12}
!9 = !DIEnumerator(name: "BPF_ANY", value: 0)
!10 = !DIEnumerator(name: "BPF_NOEXIST", value: 1)
!11 = !DIEnumerator(name: "BPF_EXIST", value: 2)
!12 = !DIEnumerator(name: "BPF_F_LOCK", value: 4)
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!16 = !{!0, !17, !23, !27, !44, !53}
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 57, type: !19, isLocal: false, isDefinition: true)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 32, elements: !21)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !{!22}
!22 = !DISubrange(count: 4)
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "_version", scope: !2, file: !3, line: 58, type: !25, isLocal: false, isDefinition: true)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !26, line: 27, baseType: !7)
!26 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !3, line: 24, type: !29, isLocal: false, isDefinition: true)
!29 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 19, size: 256, elements: !30)
!30 = !{!31, !37, !42, !43}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !29, file: !3, line: 20, baseType: !32, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 32, elements: !35)
!34 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!35 = !{!36}
!36 = !DISubrange(count: 1)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !29, file: !3, line: 21, baseType: !38, size: 64, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 2048, elements: !40)
!40 = !{!41}
!41 = !DISubrange(count: 64)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !29, file: !3, line: 22, baseType: !14, size: 64, offset: 128)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !29, file: !3, line: 23, baseType: !14, size: 64, offset: 192)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !46, line: 56, type: !47, isLocal: true, isDefinition: true)
!46 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DISubroutineType(types: !49)
!49 = !{!50, !50, !51}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !46, line: 78, type: !55, isLocal: true, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{!15, !50, !51, !51, !58}
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !26, line: 31, baseType: !59)
!59 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!60 = !DIFile(filename: "./prog.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/countsyscalls", checksumkind: CSK_MD5, checksum: "ca283b648331945797a8a9083f00a6f4")
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !62, size: 576, elements: !69)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscallNames", file: !60, line: 2, size: 192, elements: !63)
!63 = !{!64, !65}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !62, file: !60, line: 2, baseType: !15, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !62, file: !60, line: 2, baseType: !66, size: 120, offset: 64)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 120, elements: !67)
!67 = !{!68}
!68 = !DISubrange(count: 15)
!69 = !{!70}
!70 = !DISubrange(count: 3)
!71 = !{i32 7, !"Dwarf Version", i32 5}
!72 = !{i32 2, !"Debug Info Version", i32 3}
!73 = !{i32 1, !"wchar_size", i32 4}
!74 = !{i32 7, !"frame-pointer", i32 2}
!75 = !{!"clang version 15.0.7"}
!76 = distinct !DISubprogram(name: "countSyscalls", scope: !3, file: !3, line: 28, type: !77, scopeLine: 28, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !94)
!77 = !DISubroutineType(types: !78)
!78 = !{!34, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_args", file: !3, line: 6, size: 512, elements: !81)
!81 = !{!82, !84, !86, !87, !88, !89}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "common_type", scope: !80, file: !3, line: 11, baseType: !83, size: 16)
!83 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "common_flags", scope: !80, file: !3, line: 12, baseType: !85, size: 8, offset: 16)
!85 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "common_preempt_count", scope: !80, file: !3, line: 13, baseType: !85, size: 8, offset: 24)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "common_pid", scope: !80, file: !3, line: 14, baseType: !34, size: 32, offset: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !80, file: !3, line: 15, baseType: !15, size: 64, offset: 64)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !80, file: !3, line: 16, baseType: !90, size: 384, offset: 128)
!90 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 384, elements: !92)
!91 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!92 = !{!93}
!93 = !DISubrange(count: 6)
!94 = !{!95, !96, !97, !98, !99, !101}
!95 = !DILocalVariable(name: "ctx", arg: 1, scope: !76, file: !3, line: 28, type: !79)
!96 = !DILocalVariable(name: "id", scope: !76, file: !3, line: 29, type: !15)
!97 = !DILocalVariable(name: "found", scope: !76, file: !3, line: 30, type: !34)
!98 = !DILocalVariable(name: "qtd", scope: !76, file: !3, line: 31, type: !15)
!99 = !DILocalVariable(name: "i", scope: !100, file: !3, line: 34, type: !34)
!100 = distinct !DILexicalBlock(scope: !76, file: !3, line: 34, column: 5)
!101 = !DILocalVariable(name: "value", scope: !76, file: !3, line: 46, type: !14)
!102 = !DILocation(line: 0, scope: !76)
!103 = !DILocation(line: 29, column: 5, scope: !76)
!104 = !DILocation(line: 29, column: 20, scope: !76)
!105 = !{!106, !111, i64 8}
!106 = !{!"syscalls_enter_args", !107, i64 0, !108, i64 2, !108, i64 3, !110, i64 4, !111, i64 8, !108, i64 16}
!107 = !{!"short", !108, i64 0}
!108 = !{!"omnipotent char", !109, i64 0}
!109 = !{!"Simple C/C++ TBAA"}
!110 = !{!"int", !108, i64 0}
!111 = !{!"long", !108, i64 0}
!112 = !DILocation(line: 29, column: 10, scope: !76)
!113 = !{!111, !111, i64 0}
!114 = !DILocation(line: 31, column: 5, scope: !76)
!115 = !DILocation(line: 31, column: 10, scope: !76)
!116 = !DILocation(line: 0, scope: !100)
!117 = !DILocation(line: 35, column: 30, scope: !118)
!118 = distinct !DILexicalBlock(scope: !119, file: !3, line: 35, column: 13)
!119 = distinct !DILexicalBlock(scope: !120, file: !3, line: 34, column: 36)
!120 = distinct !DILexicalBlock(scope: !100, file: !3, line: 34, column: 5)
!121 = !{!122, !111, i64 0}
!122 = !{!"syscallNames", !111, i64 0, !108, i64 8}
!123 = !DILocation(line: 35, column: 33, scope: !118)
!124 = !DILocation(line: 35, column: 13, scope: !119)
!125 = !DILocation(line: 46, column: 26, scope: !76)
!126 = !DILocation(line: 47, column: 15, scope: !127)
!127 = distinct !DILexicalBlock(scope: !76, file: !3, line: 47, column: 9)
!128 = !DILocation(line: 47, column: 9, scope: !76)
!129 = !DILocation(line: 50, column: 14, scope: !76)
!130 = !DILocation(line: 50, column: 21, scope: !76)
!131 = !DILocation(line: 50, column: 12, scope: !76)
!132 = !DILocation(line: 51, column: 5, scope: !76)
!133 = !DILocation(line: 54, column: 1, scope: !76)
