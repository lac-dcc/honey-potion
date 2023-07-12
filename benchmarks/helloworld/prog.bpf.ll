; ModuleID = 'prog.bpf.c'
source_filename = "prog.bpf.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf"

@helloWorld.____fmt = internal constant [38 x i8] c"Hello World, this is a new syscall :)\00", align 1, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !25
@_version = dso_local global i32 393984, section "version", align 4, !dbg !31
@llvm.compiler.used = appending global [3 x ptr] [ptr @_license, ptr @_version, ptr @helloWorld], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @helloWorld(ptr nocapture readnone %0) #0 section "tracepoint/raw_syscalls/sys_enter" !dbg !2 {
  call void @llvm.dbg.value(metadata ptr poison, metadata !45, metadata !DIExpression()), !dbg !54
  %2 = tail call i64 (ptr, i32, ...) inttoptr (i64 6 to ptr)(ptr noundef nonnull @helloWorld.____fmt, i32 noundef 38) #2, !dbg !55
  ret i32 0, !dbg !57
}

; Function Attrs: nocallback nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" }
attributes #1 = { nocallback nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind }

!llvm.dbg.cu = !{!23}
!llvm.module.flags = !{!49, !50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "____fmt", scope: !2, file: !3, line: 21, type: !46, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "helloWorld", scope: !3, file: !3, line: 20, type: !4, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !23, retainedNodes: !44)
!3 = !DIFile(filename: "prog.bpf.c", directory: "/run/media/kaelsa/1tera/KaelMedia/KPrograms/GitHub/honey-potion/benchmarks/programs/helloworld", checksumkind: CSK_MD5, checksum: "39a5b0953bd8b0b470a0f703d7e67768")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !7}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "syscalls_enter_args", file: !3, line: 5, size: 512, elements: !9)
!9 = !{!10, !12, !14, !15, !16, !18}
!10 = !DIDerivedType(tag: DW_TAG_member, name: "common_type", scope: !8, file: !3, line: 10, baseType: !11, size: 16)
!11 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!12 = !DIDerivedType(tag: DW_TAG_member, name: "common_flags", scope: !8, file: !3, line: 11, baseType: !13, size: 8, offset: 16)
!13 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "common_preempt_count", scope: !8, file: !3, line: 12, baseType: !13, size: 8, offset: 24)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "common_pid", scope: !8, file: !3, line: 13, baseType: !6, size: 32, offset: 32)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !8, file: !3, line: 14, baseType: !17, size: 64, offset: 64)
!17 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !8, file: !3, line: 15, baseType: !19, size: 384, offset: 128)
!19 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 384, elements: !21)
!20 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!21 = !{!22}
!22 = !DISubrange(count: 6)
!23 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 15.0.7", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, globals: !24, splitDebugInlining: false, nameTableKind: None)
!24 = !{!0, !25, !31, !36}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "_license", scope: !23, file: !3, line: 27, type: !27, isLocal: false, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 32, elements: !29)
!28 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!29 = !{!30}
!30 = !DISubrange(count: 4)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "_version", scope: !23, file: !3, line: 28, type: !33, isLocal: false, isDefinition: true)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !34, line: 27, baseType: !35)
!34 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "", checksumkind: CSK_MD5, checksum: "b810f270733e106319b67ef512c6246e")
!35 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !23, file: !38, line: 177, type: !39, isLocal: true, isDefinition: true)
!38 = !DIFile(filename: "/usr/include/bpf/bpf_helper_defs.h", directory: "", checksumkind: CSK_MD5, checksum: "7422ca06c9dc86eba2f268a57d8acf2f")
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DISubroutineType(types: !41)
!41 = !{!17, !42, !33, null}
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !28)
!44 = !{!45}
!45 = !DILocalVariable(name: "ctx", arg: 1, scope: !2, file: !3, line: 20, type: !7)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 304, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 38)
!49 = !{i32 7, !"Dwarf Version", i32 5}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{i32 7, !"frame-pointer", i32 2}
!53 = !{!"clang version 15.0.7"}
!54 = !DILocation(line: 0, scope: !2)
!55 = !DILocation(line: 21, column: 3, scope: !56)
!56 = distinct !DILexicalBlock(scope: !2, file: !3, line: 21, column: 3)
!57 = !DILocation(line: 23, column: 3, scope: !2)
