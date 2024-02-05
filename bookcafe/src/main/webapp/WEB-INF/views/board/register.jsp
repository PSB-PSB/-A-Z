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
            <!-- /.row -->
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
            
            
                
<%@include file="../includes/footer.jsp" %>
