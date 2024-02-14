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
            	width: 20px;
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
            
            <script>
            	$(document).ready(function(e){
            		var formObj = $("form[role='form]']").on("click", function(e){
            			e.preventDefault();
            			
            			console.log("submit clicked");
            			
            			
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
        				
        				$.ajax({
        					url: '/uploadAjaxAction',
        					processData: false,
        					contentType: false,data:
        					formData,type: 'POST',
        					dataType:'json',
        					success:function(result){
        						console.log(result);
        					}
        				}); //$.ajax
        			});
            	});
            </script>
            
            
                
<%@include file="../includes/footer.jsp" %>
