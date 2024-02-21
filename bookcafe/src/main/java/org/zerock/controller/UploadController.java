package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.attribute.UserPrincipalNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.server.reactive.HttpHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	
	// 현재 날짜를 기반으로 폴더 이름을 생성하는 메서드
	private String getForlder() {
		
		// 날짜 포맷을 설정하는 SimpleDateFormat 객체 생성
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		// 현재 날짜를 나타내는 Date 객체 생성
		Date date = new Date();
		
		// 날짜를 지정된 포맷으로 변환하여 문자열로 저장
		String str = sdf.format(date);
		
		// 파일 시스템에 따라 사용되는 구분자로 변환
        // 예: Windows의 경우 "-", Unix/Linux의 경우 "/"
		return str.replace("-", File.separator);
	}
	
	private boolean checkImageType(File file) {
		try {
			// 파일의 ContentType을 확인하여 이미지인지 여부를 판단
			String contentType = Files.probeContentType(file.toPath());
			// ContentType의 startsWith함수가 "image"로 시작하면 이미지 파일로 판단.
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		
			String uploadFolder = "C:\\upload";
		
		for(MultipartFile multipartFile : uploadFile) {
			
			log.info("----------------");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload File Size : " + multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.info(e.getMessage());
			}
		}
	} // end uploadFormPost
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>>
	uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("update ajax post...");
		
		// 업로드된 파일 정보를 담을 리스트 생성
		List<AttachFileDTO> list = new ArrayList<>();
		
		//파일을 업로드할 기본 폴더 경로
		String uploadFolder = "C:\\upload";
		
		//폴더 만드는 부분 -------
		String uploadFolderPath = getForlder();
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		log.info("업로드 경로 : " + uploadPath);
		
		// 업로드 경로가 존재하지 않을 경우 폴더 생성
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		// 각 파일에 대해 업로드 처리 수행
		for(MultipartFile multipartFile : uploadFile) {
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			// 업로드된 파일의 이름 가져오기
			String uploadFileName = multipartFile.getOriginalFilename();
			
			 // Internet Explorer의 경우 파일 경로 제거
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			
			//파일 이름 설정.
			attachDTO.setFileName(uploadFileName);
			
			//중복 방지 UUID
			UUID uuid = UUID.randomUUID();
			
			//파일 이름에 하이픈 추가해서 중복 파일 이름 방지.
			uploadFileName = uuid.toString() + "_" + uploadFileName;
					
			try {
				//년 월 일에 생성된 파일저장.
				File saveFile = new File(uploadPath, uploadFileName);
				
				// 업로드된 파일을 저장 경로로 이동
				multipartFile.transferTo(saveFile);
				
				// AttachFileDTO에 파일 정보 설정
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// 파일이 이미지 타입인지 체크해서 썸네일을 만듬.
				if(checkImageType(saveFile)) {
					
					// 이미지 파일인 경우에만 이미지 플래그를 true로 설정
					attachDTO.setImage(true);
					
					// 썸네일 생성부분
					FileOutputStream thumbnail = 
					new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					
					thumbnail.close();
				}
				
				// 리스트에 AttachFileDTO 추가
				list.add(attachDTO);
				
			} catch (Exception e) {
				log.error(e.getMessage());
			}
		} // end for
		// ResponseEntity를 사용하여 리스트와 HTTP 상태코드 반환
		return new ResponseEntity<>(list, HttpStatus.OK);

	} // end uploadAjaxAction
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		
		// 요청된 파일 이름 로깅
		log.info("파일 이름 : " + fileName);
		
		// 요청된 파일 경로 생성
		File file = new File("c:\\upload\\" + fileName);
		
		
		// 요청된 파일 이름 로깅
		log.info("파일 : " + file);
		
		// 응답 엔터티 초기화
		ResponseEntity<byte[]> result = null;
		
		try {
			// 파일의 Content-Type 추출하여 헤더 설정
			HttpHeaders header = new HttpHeaders();
			
			// 파일의 바이트 배열을 복사하여 응답 엔터티 생성
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),
					header, HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value ="/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		log.info("다운로드 파일 : " + fileName);
		
		// 다운로드할 파일의 경로를 지정하여 Resource 객체 생성
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);
		
		log.info("resource" + resource);
		
		// 파일이 존재하지 않는 경우 404 응답 반환
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		// 다운로드할 파일의 이름을 가져옴
		String resourceName = resource.getFilename();
		
		//UUID 지우기
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		// HTTP 응답 헤더 설정
		HttpHeaders headers = new HttpHeaders();
		
		try {
			
			//다운로드될 파일의 이름을 저장하는 변수를 선언하기위해 초기화
			String downloadName = null;
			
			// User-Agent 헤더를 기반으로 브라우저 종류를 파악하여 파일 이름 인코딩 처리
			if(userAgent.contains("Trident")) {
				
				log.info("IE 브라우저");
				
				// IE 브라우저인 경우 파일 이름을 UTF-8로 인코딩한 후 공백을 +로 치환하여 설정
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			}else if(userAgent.contains("Edge")) {
				
				log.info("엣지 브라우저");
				
				// Edge 브라우저인 경우 파일 이름을 UTF-8로 인코딩하여 설정
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				
				log.info("엣지 name : " + downloadName);
			}else {
				
				log.info("크롬 브라우저");
				
				// 그 외의 브라우저인 경우(나는 일단 크롬만 쓸거니까 로그에는 크롬 브라우저만) 파일 이름을 ISO-8859-1로 인코딩하여 설정
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"),"ISO-8859-1");
			}
			
			headers.add("Content-Disposition", "attachment; fileName=" + downloadName);
		
			
		} catch (UnsupportedEncodingException  e) {
			// 예외 발생 시 오류 출력
			e.printStackTrace();
		}
		
		// 다운로드할 파일의 Resource와 설정된 헤더를 이용하여 ResponseEntity 생성하여 반환
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		
		// 파일 삭제를 위해 받은 파일 이름 로깅
		log.info("삭제 하는 파일 이름 : " + fileName);
		
		// 파일을 객체로 선언함.
		File file;
		
		try {
			// 파일 경로에서 한글을 디코딩하여 파일 객체 생성함.
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
				
			// 파일 삭제
			file.delete();
			
			// if의 조건 파일 타입이 이미지인 경우
			if(type.equals("image")) {
				
				// 원본 이미지 파일의 이름을 가져오기 위해 "s_"를 제거하여 대용량 파일 이름 생성함
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				
				// 대용량 이미지 파일 로깅
				log.info("largeFileName" + largeFileName);
				
				// 대용량 이미지 파일 객체 생성함
				file = new File(largeFileName);
				
				// 대용량 이미지 파일 삭제
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			// 인코딩 오류가 발생한 경우 로깅 및 NOT_FOUND 응답 반환
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		// 파일 삭제 완료 응답 반환
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
