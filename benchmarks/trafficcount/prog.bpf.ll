; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

%struct.anon = type { ptr, ptr, ptr, ptr }
%struct.countentry = type { i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.xdp_md = type { i32, i32, i32, i32, i32, i32 }

@map = dso_local global %struct.anon zeroinitializer, section ".maps", align 8, !dbg !0
@_license = dso_local global [13 x i8] c"Dual BSD/GPL\00", section "license", align 1, !dbg !31
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @map, ptr @trafficCount], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @trafficCount(ptr nocapture noundef readonly %0) #0 section "xdp_traffic_count" !dbg !77 {
  %2 = alloca %struct.countentry, align 4
  %3 = getelementptr inbounds %struct.countentry, ptr %2, i64 0, i32 1, !dbg !109
  call void @llvm.dbg.value(metadata ptr %0, metadata !91, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata i32 undef, metadata !92, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !109
  %4 = load i32, ptr %0, align 4, !dbg !110, !tbaa !111
  %5 = zext i32 %4 to i64, !dbg !116
  %6 = inttoptr i64 %5 to ptr, !dbg !117
  call void @llvm.dbg.value(metadata ptr %6, metadata !93, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata ptr %6, metadata !94, metadata !DIExpression()), !dbg !109
  %7 = getelementptr inbounds %struct.ethhdr, ptr %6, i64 0, i32 1, !dbg !118
  call void @llvm.dbg.value(metadata ptr %7, metadata !106, metadata !DIExpression()), !dbg !109
  %8 = getelementptr inbounds %struct.xdp_md, ptr %0, i64 0, i32 1, !dbg !119
  %9 = load i32, ptr %8, align 4, !dbg !119, !tbaa !120
  call void @llvm.dbg.value(metadata i32 %9, metadata !92, metadata !DIExpression(DW_OP_LLVM_convert, 32, DW_ATE_unsigned, DW_OP_LLVM_convert, 64, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !109
  %10 = zext i32 %9 to i64, !dbg !121
  call void @llvm.dbg.value(metadata i64 %10, metadata !92, metadata !DIExpression()), !dbg !109
  %11 = inttoptr i64 %10 to ptr, !dbg !122
  call void @llvm.dbg.value(metadata ptr %11, metadata !92, metadata !DIExpression()), !dbg !109
  %12 = getelementptr i8, ptr %6, i64 13, !dbg !123
  %13 = icmp ult ptr %12, %11, !dbg !125
  br i1 %13, label %14, label %27, !dbg !126

14:                                               ; preds = %1
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %2) #4, !dbg !127
  call void @llvm.dbg.declare(metadata ptr %2, metadata !107, metadata !DIExpression()), !dbg !128
  %15 = tail call ptr inttoptr (i64 1 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %7) #4, !dbg !129
  call void @llvm.dbg.value(metadata ptr %15, metadata !108, metadata !DIExpression()), !dbg !109
  %16 = icmp eq ptr %15, null, !dbg !130
  br i1 %16, label %21, label %17, !dbg !132

17:                                               ; preds = %14
  %18 = getelementptr inbounds %struct.countentry, ptr %15, i64 0, i32 1, !dbg !109
  %19 = load i32, ptr %18, align 4, !dbg !133, !tbaa !134
  %20 = add i32 %19, 1, !dbg !132
  br label %22, !dbg !132

21:                                               ; preds = %14
  call void @llvm.dbg.value(metadata ptr %2, metadata !108, metadata !DIExpression()), !dbg !109
  store i32 0, ptr %2, align 4, !dbg !136, !tbaa !138
  store i32 0, ptr %3, align 4, !dbg !139, !tbaa !134
  br label %22, !dbg !140

22:                                               ; preds = %17, %21
  %23 = phi i32 [ 1, %21 ], [ %20, %17 ]
  %24 = phi ptr [ %2, %21 ], [ %15, %17 ], !dbg !109
  %25 = phi ptr [ %3, %21 ], [ %18, %17 ], !dbg !109
  call void @llvm.dbg.value(metadata ptr %24, metadata !108, metadata !DIExpression()), !dbg !109
  store i32 %23, ptr %25, align 4, !dbg !133, !tbaa !134
  %26 = call i64 inttoptr (i64 2 to ptr)(ptr noundef nonnull @map, ptr noundef nonnull %7, ptr noundef nonnull %24, i64 noundef 0) #4, !dbg !141
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %2) #4, !dbg !142
  br label %27

27:                                               ; preds = %1, %22
  ret i32 2, !dbg !142
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: argmemonly mustprogress nocallback nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #2

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly mustprogress nocallback nofree nosync nounwind willreturn }
attributes #3 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!72, !73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map", scope: !2, file: !3, line: 13, type: !53, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !20, globals: !30, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/trafficcount", checksumkind: CSK_MD5, checksum: "ddcba8d185ab5f215f31788171ed1f21")
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
!20 = !{!21, !22, !23}
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!22 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "countentry", file: !25, line: 1, size: 64, elements: !26)
!25 = !DIFile(filename: "./prog.h", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/trafficcount", checksumkind: CSK_MD5, checksum: "5cf3bae129fdff1e3fb04e4fed453a29")
!26 = !{!27, !29}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "bytes", scope: !24, file: !25, line: 2, baseType: !28, size: 32)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "packets", scope: !24, file: !25, line: 3, baseType: !28, size: 32, offset: 32)
!30 = !{!31, !0, !37, !45}
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 49, type: !33, isLocal: false, isDefinition: true)
!33 = !DICompositeType(tag: DW_TAG_array_type, baseType: !34, size: 104, elements: !35)
!34 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!35 = !{!36}
!36 = !DISubrange(count: 13)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !39, line: 56, type: !40, isLocal: true, isDefinition: true)
!39 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DISubroutineType(types: !42)
!42 = !{!21, !21, !43}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !39, line: 78, type: !47, isLocal: true, isDefinition: true)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DISubroutineType(types: !49)
!49 = !{!22, !21, !43, !43, !50}
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !51, line: 31, baseType: !52)
!51 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!52 = !DIBasicType(name: "unsigned long long", size: 64, encoding: DW_ATE_unsigned)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !3, line: 8, size: 256, elements: !54)
!54 = !{!55, !60, !65, !71}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !53, file: !3, line: 9, baseType: !56, size: 64)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 32, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 1)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !53, file: !3, line: 10, baseType: !61, size: 64, offset: 64)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 8192, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 256)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !53, file: !3, line: 11, baseType: !66, size: 64, offset: 128)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 48, elements: !69)
!68 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!69 = !{!70}
!70 = !DISubrange(count: 6)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !53, file: !3, line: 12, baseType: !23, size: 64, offset: 192)
!72 = !{i32 7, !"Dwarf Version", i32 5}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{i32 7, !"frame-pointer", i32 2}
!76 = !{!"clang version 15.0.7"}
!77 = distinct !DISubprogram(name: "trafficCount", scope: !3, file: !3, line: 19, type: !78, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !90)
!78 = !DISubroutineType(types: !79)
!79 = !{!28, !80}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 6141, size: 192, elements: !82)
!82 = !{!83, !85, !86, !87, !88, !89}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !81, file: !6, line: 6142, baseType: !84, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !51, line: 27, baseType: !7)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !81, file: !6, line: 6143, baseType: !84, size: 32, offset: 32)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !81, file: !6, line: 6144, baseType: !84, size: 32, offset: 64)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !81, file: !6, line: 6146, baseType: !84, size: 32, offset: 96)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !81, file: !6, line: 6147, baseType: !84, size: 32, offset: 128)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "egress_ifindex", scope: !81, file: !6, line: 6149, baseType: !84, size: 32, offset: 160)
!90 = !{!91, !92, !93, !94, !106, !107, !108}
!91 = !DILocalVariable(name: "ctx", arg: 1, scope: !77, file: !3, line: 19, type: !80)
!92 = !DILocalVariable(name: "end", scope: !77, file: !3, line: 21, type: !21)
!93 = !DILocalVariable(name: "data", scope: !77, file: !3, line: 22, type: !21)
!94 = !DILocalVariable(name: "eth", scope: !77, file: !3, line: 23, type: !95)
!95 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!96 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !97, line: 173, size: 112, elements: !98)
!97 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "", checksumkind: CSK_MD5, checksum: "163f54fb1af2e21fea410f14eb18fa76")
!98 = !{!99, !100, !101}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !96, file: !97, line: 174, baseType: !67, size: 48)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !96, file: !97, line: 175, baseType: !67, size: 48, offset: 48)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !96, file: !97, line: 176, baseType: !102, size: 16, offset: 96)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !103, line: 28, baseType: !104)
!103 = !DIFile(filename: "/usr/include/linux/types.h", directory: "", checksumkind: CSK_MD5, checksum: "64bcf4b731906682de6e750679b9f4a2")
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !51, line: 24, baseType: !105)
!105 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!106 = !DILocalVariable(name: "src", scope: !77, file: !3, line: 24, type: !21)
!107 = !DILocalVariable(name: "newitem", scope: !77, file: !3, line: 32, type: !24)
!108 = !DILocalVariable(name: "item", scope: !77, file: !3, line: 33, type: !23)
!109 = !DILocation(line: 0, scope: !77)
!110 = !DILocation(line: 22, column: 37, scope: !77)
!111 = !{!112, !113, i64 0}
!112 = !{!"xdp_md", !113, i64 0, !113, i64 4, !113, i64 8, !113, i64 12, !113, i64 16, !113, i64 20}
!113 = !{!"int", !114, i64 0}
!114 = !{!"omnipotent char", !115, i64 0}
!115 = !{!"Simple C/C++ TBAA"}
!116 = !DILocation(line: 22, column: 26, scope: !77)
!117 = !DILocation(line: 22, column: 18, scope: !77)
!118 = !DILocation(line: 24, column: 22, scope: !77)
!119 = !DILocation(line: 21, column: 36, scope: !77)
!120 = !{!112, !113, i64 4}
!121 = !DILocation(line: 21, column: 25, scope: !77)
!122 = !DILocation(line: 21, column: 17, scope: !77)
!123 = !DILocation(line: 29, column: 13, scope: !124)
!124 = distinct !DILexicalBlock(scope: !77, file: !3, line: 29, column: 9)
!125 = !DILocation(line: 29, column: 17, scope: !124)
!126 = !DILocation(line: 29, column: 9, scope: !77)
!127 = !DILocation(line: 32, column: 5, scope: !77)
!128 = !DILocation(line: 32, column: 23, scope: !77)
!129 = !DILocation(line: 33, column: 52, scope: !77)
!130 = !DILocation(line: 36, column: 14, scope: !131)
!131 = distinct !DILexicalBlock(scope: !77, file: !3, line: 36, column: 9)
!132 = !DILocation(line: 36, column: 9, scope: !77)
!133 = !DILocation(line: 43, column: 18, scope: !77)
!134 = !{!135, !113, i64 4}
!135 = !{!"countentry", !113, i64 0, !113, i64 4}
!136 = !DILocation(line: 39, column: 21, scope: !137)
!137 = distinct !DILexicalBlock(scope: !131, file: !3, line: 36, column: 20)
!138 = !{!135, !113, i64 0}
!139 = !DILocation(line: 40, column: 23, scope: !137)
!140 = !DILocation(line: 41, column: 5, scope: !137)
!141 = !DILocation(line: 44, column: 5, scope: !77)
!142 = !DILocation(line: 47, column: 1, scope: !77)
