package com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager

interface PdPatchFileManager {
    val openedPatches: List<PatchFile>
    fun openPatch(file: PatchFile)
    fun closePatch(file: PatchFile)
}

data class PatchFile(val name: String, val path: String) {
    val fullPath: String
    get() = "$path$name"
}

sealed class PatchFileError : Exception() {
    data class OpenFailed(val file: PatchFile): PatchFileError()
}
