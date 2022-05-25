package com.study.common.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class StudyAttachUtils {
	
	public void getAttachListByMultiparts(MultipartFile[] boFiles) throws IOException {
		for(MultipartFile boFile : boFiles) {
			getAttachByMultipart(boFile);
		}
	}
	
	public void getAttachByMultipart(MultipartFile boFile) throws IOException {
		String fileName = UUID.randomUUID().toString();
		FileUtils.copyInputStreamToFile(boFile.getInputStream()
				, new File("/home/pc54/upload/free", fileName)); // 여기서 실제로 파일저장
	}
	
	public String fancySize(long size) {
		
		return size/1024l + "MB";
	}
}
