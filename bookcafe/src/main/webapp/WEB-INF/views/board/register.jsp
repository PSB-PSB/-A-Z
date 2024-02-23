<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp" %>
   <div class="row">
       <div class="col-lg-12">
           <h1 class="page-header">Board Register</h1>
       </div>
       <!-- /.col-lg-12 -->
   </div>
   <!-- row -->
   <div class="row">
       <div class="col-lg-12">
           <div class="panel panel-default">
               <div class="panel-heading">
                   Board Register
               </div>
               <!-- /.panel-heading -->
                <div class="panel-body">
                   <form action="/board/register" method="post">
                   	<div class="form-group">
                         <label>Title</label>
                         <input class="form-control" name="title">
                     </div>
                     <div class="form-group">
                         <label>content</label>
                         <textarea class="form-control" name="content" rows="5"></textarea>
                     </div>
                   	<div class="form-group">
                         <label>Writer</label>
                         <input class="form-control" name="writer">
                     </div>
                     <div class="dox-footer">
						<button type="submit" class="btn btn-primary">Submit</button>
					 </div>
                   </form>
                    
                </div>
                <!-- /.panel-body -->
           </div>
           <!-- /.panel -->
       </div>
       <!-- /.col-lg-12 -->
   </div>
   <!-- /.row -->
   
   <!-- 파일 업로드 부분 -->
   <style>
   .uploadResult{
   	width:100%;
   	background: gray;
   }
   .uploadResult ul{
   	display: flex;
   	flex-flow: row;
   	justify-content: center;
   	align-items: center;
   }
   .uploadResult ul li{
   	list-style: none;
   	padding: 10px;
   }
   .uploadResult ul li img{
   	width: 300px;
   }
   </style>
   <div class="row">
       <div class="col-lg-12">
           <div class="panel panel-default">
               <div class="panel-heading">
                   File Attach
               </div>
               <!-- /.panel-heading -->
               <div class="panel-body">
                  	<div class="form-group uploadDiv">
                        <input type="file" name="uploadFile" multiple>
                    </div>
                    
                    <div class="uploadResult">
                    	<ul>
                    	
                    	</ul>
                    </div>
               </div>
               <!-- /.panel-body -->
           </div>
           <!-- /.panel -->
       </div>
       <!-- /.col-lg-12 -->
   </div>
   <script src="https://code.jquery.com/jquery-3.7.1.min.js"
 	integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
  	crossorigin="anonymous"></script>
   <script>
   	$(document).ready(function(e){
   		
   		var formObj = $("form[role='form']");

   		$("button[type='submit']").on("click", function (e) {
   		    e.preventDefault();

   		    console.log("전송 클릭");

   		    var str = "";

   		    $(".uploadResult ul li").each(function (i, obj) {
   		        var jobj = $(obj);

   		        console.dir(jobj);

   		        str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
   		        str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
   		        str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
   		        str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
   		    });
   		    formObj.append(str).submit();
   		});
   		
   		var regex = new RegExp("(.*?)\.(exe|sh|zip|aiz)$");
		
		var maxSize = 5242880; //5MB
		
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 불가능합니다.");
				return false;
			}
			return true;
		}
		
		$("input[type='file']").change(function(e){
			var formData = new FormData();
			
			var inputFile = $("input[name='uploadFile']");
			
			var files = inputFile[0].files;
			
			for(var i = 0; i < files.length; i++){
				
				if(!checkExtension(files[i].name, files[i].size)){
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			function showUploadResult(uploadResultArr){
	   			if(!uploadResultArr || uploadResultArr.length == 0){
	   				return;
	   			}
	   			var uploadUL = $(".uploadResult ul");
	   			
	   			var str = "";
	   			
	   			$(uploadResultArr).each(function(i, obj){
	   				if(obj.image){
	   					
	   					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
	   					str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>";
	   					str += "<div>";
	   					str += "<span> " + obj.fileName+"</span>";
	   					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
	   					str += "<img src='/display?fileName="+fileCallPath+"'>";
	   					str += "</div>";
	   					str += "</li>";
	   					
	   				}else{
	   					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
	   					
	   					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
	   					
	   					str += "<li data-path='"+obj.uploadPath+"'";
	   					str += "data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'"
	   					str += " ></div>";
	   					str += "<span> " + obj.fileName+"</span>";
	   					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>"
	   					str += "<img src='/resources/img/attach.png'></a>";
	   					str += "</div>";
	   					str += "</li>";
	   				}
	   			});
	   			uploadUL.append(str);
	   		}
			

			//업로드 처리 ajax
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,data:
				formData,type: 'POST',
				dataType:'json',
				success:function(result){
					console.log(result);
					showUploadResult(result); //업로드 결과 처리
				}
			}); //$.ajax
			
			$(".uploadResult").on("click", "button", function(e){
				console.log("삭제함.");
				
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				
				var targetLi = $(this).closest("li");
				
				// 첨부파일 삭제 ajax
				$.ajax({
					url: '/deleteFile',
					data: {fileName: targetFile, type: type},
					dataType: 'text',
					type: 'POST',
						success: function(result){
							alert(result);
							targetLi.remove()
						}
				}); //$.ajax
			}); // 삭제 이벤트 끝
			
		});
   	});
   </script>
   
   
       
<%@include file="../includes/footer.jsp" %>
