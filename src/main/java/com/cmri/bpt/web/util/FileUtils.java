package com.cmri.bpt.web.util;

import java.io.File;
import java.io.IOException;
import java.util.Properties;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PropertiesLoaderUtils;

public final class FileUtils {
	
	
	 public static boolean changeFileName(String file, String toFile) {
		 File toBeRenamed = new File(file);
		//检查要重命名的文件是否存在，是否是文件
		if (!toBeRenamed.exists() || toBeRenamed.isDirectory()) {
			return false;
		}

		File newFile = new File(toFile);
		return toBeRenamed.renameTo(newFile);
	 }

	 public static String getPropertiesInResouce(String path,String key) {
		 Resource resource = new ClassPathResource(path);
		 Properties props=null;
		 String result="";
		try {
			props = PropertiesLoaderUtils.loadProperties(resource);
			result=props.getProperty(key);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	 }
}
