<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Read</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board Read
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                       		<div class="form-group">
                                 <label>BNO</label>
                                 <input class="form-control" name="bno" readonly="readonly" value='<c:out value="${board.bno}"/>'>
                            </div>
                           	<div class="form-group">
                                 <label>Title</label>
                                 <input class="form-control" name="title" readonly="readonly" value='<c:out value="${board.title}"/>'>
                             </div>
                             <div class="form-group">
                                 <label>content</label>
                                 <textarea class="form-control" name="content" rows="5"><c:out value="${board.content}"/></textarea>
                             </div>
                           	<div class="form-group">
                                 <label>Writer</label>
                                 <input class="form-control" name="writer" value='<c:out value="${board.writer}"/>'>
                             </div>
                             
                             <form id="actionFrom" action="/board/list" method="get">
								<input type='hidden' name='pageNum' value='${cri.pageNum }'>
								<input type='hidden' name='amount' value='${cri.amount }'>
								<input type='hidden' name='bno' value='${board.bno }'>
								<input type='hidden' name='type' value='${cri.type }'>
								<input type='hidden' name='keyword' value='${cri.keyword }'>
							 </form>
							 
                             <div class="dox-footer">
								<button type="button" class="btn btn-default listBtn"><a href='/board/list'>List</a></button>
								<button type="button" class="btn btn-default modBtn"><a href='/board/modify?bno=<c:out value="${board.bno}"/>'>Modify</a></button>
							 </div>
                            
                            <script>
                            	
                            var actionFrom = $("#actionFrom");
                            
                            	$(".listBtn").click(function(e){
                            		e.preventDefault();
                            		actionFrom.find("input[name=bno]").remove();
                            		actionFrom.submit();
                            	});
                            	$(".modBtn").click(function(e){
                            		e.preventDefault();
                            		actionFrom.attr("action","/board/modify");
                            		actionFrom.submit();
                            	});
                            </script>
                            
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            
            
                
<%@include file="../includes/footer.jsp" %>
