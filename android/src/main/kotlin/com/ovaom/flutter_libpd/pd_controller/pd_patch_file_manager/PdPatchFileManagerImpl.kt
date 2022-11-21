package com.ovaom.flutter_libpd.pd_controller.pd_patch_file_manager

import org.puredata.core.PdBase
import java.io.IOException

class PdPatchFileManagerImpl : PdPatchFileManager {
    private var openedFiles: MutableList<Pair<PatchFile, Int>> = mutableListOf()

    override val openedPatches: List<PatchFile>
        get() = openedFiles.toList().map { it.first }

    override fun openPatch(file: PatchFile) {
        if (isPatchOpened(file)) {
            return
        }
        try {
            val patchId = PdBase.openPatch(file.fullPath)
            openedFiles.add(Pair(file, patchId))
        } catch (error: IOException) {
            throw  PatchFileError.OpenFailed(file)
        }
    }

    override fun closePatch(file: PatchFile) {
        findPatchIndex(file)?.let {
            PdBase.closePatch(openedFiles[it].second)
            openedFiles.removeAt(it)
        }
    }

    private fun isPatchOpened(file: PatchFile): Boolean {
        return findPatchIndex(file) != null
    }

    private fun findPatchIndex(file: PatchFile): Int? {
        val index = openedFiles.indexOfFirst { it.first == file }
        return if (index != -1) index else null
    }
}