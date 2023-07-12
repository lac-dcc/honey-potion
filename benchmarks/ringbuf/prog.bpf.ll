; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.anon.0 = type { ptr, ptr, ptr }
%struct.trace_event_raw_sched_process_exec = type { %struct.trace_entry, i32, i32, i32, [0 x i8] }
%struct.trace_entry = type { i16, i8, i8, i32 }
%struct.event = type { i32, [16 x i8], [512 x i8] }

@heap = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@pb = dso_local global %struct.anon.0 zeroinitializer, section ".maps", align 8, !dbg !29
@LICENSE = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !23
@llvm.compiler.used = appending global [4 x ptr] [ptr @LICENSE, ptr @handle_exec, ptr @heap, ptr @pb], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @handle_exec(ptr noundef %0) #0 section "tp/sched/sched_process_exec" !dbg !107 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata ptr %0, metadata !130, metadata !DIExpression()), !dbg !134
  %3 = getelementptr inbounds %struct.trace_event_raw_sched_process_exec, ptr %0, i64 0, i32 1, !dbg !135
  %4 = load i32, ptr %3, align 4, !dbg !135, !tbaa !136
  call void @llvm.dbg.value(metadata i32 %4, metadata !131, metadata !DIExpression(DW_OP_constu, 65535, DW_OP_and, DW_OP_stack_value)), !dbg !134
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %2) #3, !dbg !143
  call void @llvm.dbg.value(metadata i32 0, metadata !133, metadata !DIExpression()), !dbg !134
  store i32 0, ptr %2, align 4, !dbg !144, !tbaa !145
  call void @llvm.dbg.value(metadata ptr %2, metadata !133, metadata !DIExpression(DW_OP_deref)), !dbg !134
  %5 = call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @heap, ptr noundef nonnull %2) #3, !dbg !146
  call void @llvm.dbg.value(metadata ptr %5, metadata !132, metadata !DIExpression()), !dbg !134
  %6 = icmp eq ptr %5, null, !dbg !147
  br i1 %6, label %19, label %7, !dbg !149

7:                                                ; preds = %1
  %8 = and i32 %4, 65535, !dbg !150
  call void @llvm.dbg.value(metadata i32 %8, metadata !131, metadata !DIExpression()), !dbg !134
  %9 = call i64 inttoptr (i64 14 to ptr)() #3, !dbg !151
  %10 = lshr i64 %9, 32, !dbg !152
  %11 = trunc i64 %10 to i32, !dbg !151
  store i32 %11, ptr %5, align 4, !dbg !153, !tbaa !154
  %12 = getelementptr inbounds %struct.event, ptr %5, i64 0, i32 1, !dbg !156
  %13 = call i64 inttoptr (i64 16 to ptr)(ptr noundef nonnull %12, i32 noundef 16) #3, !dbg !157
  %14 = getelementptr inbounds %struct.event, ptr %5, i64 0, i32 2, !dbg !158
  %15 = zext i32 %8 to i64, !dbg !159
  %16 = getelementptr i8, ptr %0, i64 %15, !dbg !159
  %17 = call i64 inttoptr (i64 45 to ptr)(ptr noundef nonnull %14, i32 noundef 512, ptr noundef %16) #3, !dbg !160
  %18 = call i64 inttoptr (i64 25 to ptr)(ptr noundef nonnull %0, ptr noundef nonnull @pb, i64 noundef 4294967295, ptr noundef nonnull %5, i64 noundef 532) #3, !dbg !161
  br label %19, !dbg !162

19:                                               ; preds = %1, %7
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %2) #3, !dbg !163
  ret i32 0, !dbg !163
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
!llvm.module.flags = !{!102, !103, !104, !105}
!llvm.ident = !{!106}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "heap", scope: !2, file: !3, line: 19, type: !74, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !20, globals: !22, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/ringbuf", checksumkind: CSK_MD5, checksum: "d385c0535dfb44f503814fffe6fc1618")
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
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 5796, baseType: !15, size: 64, elements: !16)
!15 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!16 = !{!17, !18, !19}
!17 = !DIEnumerator(name: "BPF_F_INDEX_MASK", value: 4294967295, isUnsigned: true)
!18 = !DIEnumerator(name: "BPF_F_CURRENT_CPU", value: 4294967295, isUnsigned: true)
!19 = !DIEnumerator(name: "BPF_F_CTXLEN_MASK", value: 4503595332403200, isUnsigned: true)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!22 = !{!23, !29, !0, !41, !49, !57, !64, !69}
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "LICENSE", scope: !2, file: !3, line: 44, type: !25, isLocal: false, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 104, elements: !27)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!27 = !{!28}
!28 = !DISubrange(count: 13)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "pb", scope: !2, file: !3, line: 12, type: !31, isLocal: false, isDefinition: true)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 8, size: 192, elements: !32)
!32 = !{!33, !39, !40}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !31, file: !3, line: 9, baseType: !34, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 128, elements: !37)
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !{!38}
!38 = !DISubrange(count: 4)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !31, file: !3, line: 10, baseType: !34, size: 64, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !31, file: !3, line: 11, baseType: !34, size: 64, offset: 128)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !43, line: 56, type: !44, isLocal: true, isDefinition: true)
!43 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DISubroutineType(types: !46)
!46 = !{!21, !21, !47}
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "bpf_get_current_pid_tgid", scope: !2, file: !43, line: 368, type: !51, isLocal: true, isDefinition: true)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DISubroutineType(types: !53)
!53 = !{!54}
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !55, line: 31, baseType: !56)
!55 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!56 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "bpf_get_current_comm", scope: !2, file: !43, line: 394, type: !59, isLocal: true, isDefinition: true)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DISubroutineType(types: !61)
!61 = !{!62, !21, !63}
!62 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !55, line: 27, baseType: !7)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "bpf_probe_read_str", scope: !2, file: !43, line: 1151, type: !66, isLocal: true, isDefinition: true)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DISubroutineType(types: !68)
!68 = !{!62, !21, !63, !47}
!69 = !DIGlobalVariableExpression(var: !70, expr: !DIExpression())
!70 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !43, line: 696, type: !71, isLocal: true, isDefinition: true)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DISubroutineType(types: !73)
!73 = !{!62, !21, !21, !54, !21, !54}
!74 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 14, size: 256, elements: !75)
!75 = !{!76, !81, !86, !88}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !74, file: !3, line: 15, baseType: !77, size: 64)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 192, elements: !79)
!79 = !{!80}
!80 = !DISubrange(count: 6)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !74, file: !3, line: 16, baseType: !82, size: 64, offset: 64)
!82 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !83, size: 64)
!83 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 32, elements: !84)
!84 = !{!85}
!85 = !DISubrange(count: 1)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !74, file: !3, line: 17, baseType: !87, size: 64, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !74, file: !3, line: 18, baseType: !89, size: 64, offset: 192)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "event", file: !91, line: 26, size: 4256, elements: !92)
!91 = !DIFile(filename: "./prog.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/ringbuf", checksumkind: CSK_MD5, checksum: "6751af258a2e741a8c1679ec31821ff3")
!92 = !{!93, !94, !98}
!93 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !90, file: !91, line: 27, baseType: !36, size: 32)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "comm", scope: !90, file: !91, line: 28, baseType: !95, size: 128, offset: 32)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 128, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 16)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "filename", scope: !90, file: !91, line: 29, baseType: !99, size: 4096, offset: 160)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 4096, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 512)
!102 = !{i32 7, !"Dwarf Version", i32 5}
!103 = !{i32 2, !"Debug Info Version", i32 3}
!104 = !{i32 1, !"wchar_size", i32 4}
!105 = !{i32 7, !"frame-pointer", i32 2}
!106 = !{!"clang version 15.0.7"}
!107 = distinct !DISubprogram(name: "handle_exec", scope: !3, file: !3, line: 25, type: !108, scopeLine: 26, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !129)
!108 = !DISubroutineType(types: !109)
!109 = !{!36, !110}
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_event_raw_sched_process_exec", file: !91, line: 14, size: 160, elements: !112)
!112 = !{!113, !122, !123, !124, !125}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "ent", scope: !111, file: !91, line: 15, baseType: !114, size: 64)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "trace_entry", file: !91, line: 6, size: 64, elements: !115)
!115 = !{!116, !118, !120, !121}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !114, file: !91, line: 7, baseType: !117, size: 16)
!117 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !114, file: !91, line: 8, baseType: !119, size: 8, offset: 16)
!119 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "preempt_count", scope: !114, file: !91, line: 9, baseType: !119, size: 8, offset: 24)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !114, file: !91, line: 10, baseType: !36, size: 32, offset: 32)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "__data_loc_filename", scope: !111, file: !91, line: 16, baseType: !7, size: 32, offset: 64)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "pid", scope: !111, file: !91, line: 17, baseType: !36, size: 32, offset: 96)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "old_pid", scope: !111, file: !91, line: 18, baseType: !36, size: 32, offset: 128)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "__data", scope: !111, file: !91, line: 19, baseType: !126, offset: 160)
!126 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, elements: !127)
!127 = !{!128}
!128 = !DISubrange(count: 0)
!129 = !{!130, !131, !132, !133}
!130 = !DILocalVariable(name: "ctx", arg: 1, scope: !107, file: !3, line: 25, type: !110)
!131 = !DILocalVariable(name: "fname_off", scope: !107, file: !3, line: 27, type: !7)
!132 = !DILocalVariable(name: "e", scope: !107, file: !3, line: 28, type: !89)
!133 = !DILocalVariable(name: "zero", scope: !107, file: !3, line: 29, type: !36)
!134 = !DILocation(line: 0, scope: !107)
!135 = !DILocation(line: 27, column: 28, scope: !107)
!136 = !{!137, !142, i64 8}
!137 = !{!"trace_event_raw_sched_process_exec", !138, i64 0, !142, i64 8, !142, i64 12, !142, i64 16, !140, i64 20}
!138 = !{!"trace_entry", !139, i64 0, !140, i64 2, !140, i64 3, !142, i64 4}
!139 = !{!"short", !140, i64 0}
!140 = !{!"omnipotent char", !141, i64 0}
!141 = !{!"Simple C/C++ TBAA"}
!142 = !{!"int", !140, i64 0}
!143 = !DILocation(line: 29, column: 2, scope: !107)
!144 = !DILocation(line: 29, column: 6, scope: !107)
!145 = !{!142, !142, i64 0}
!146 = !DILocation(line: 31, column: 6, scope: !107)
!147 = !DILocation(line: 32, column: 7, scope: !148)
!148 = distinct !DILexicalBlock(scope: !107, file: !3, line: 32, column: 6)
!149 = !DILocation(line: 32, column: 6, scope: !107)
!150 = !DILocation(line: 27, column: 48, scope: !107)
!151 = !DILocation(line: 35, column: 11, scope: !107)
!152 = !DILocation(line: 35, column: 38, scope: !107)
!153 = !DILocation(line: 35, column: 9, scope: !107)
!154 = !{!155, !142, i64 0}
!155 = !{!"event", !142, i64 0, !140, i64 4, !140, i64 20}
!156 = !DILocation(line: 36, column: 27, scope: !107)
!157 = !DILocation(line: 36, column: 2, scope: !107)
!158 = !DILocation(line: 37, column: 25, scope: !107)
!159 = !DILocation(line: 37, column: 68, scope: !107)
!160 = !DILocation(line: 37, column: 2, scope: !107)
!161 = !DILocation(line: 39, column: 2, scope: !107)
!162 = !DILocation(line: 41, column: 2, scope: !107)
!163 = !DILocation(line: 42, column: 1, scope: !107)
