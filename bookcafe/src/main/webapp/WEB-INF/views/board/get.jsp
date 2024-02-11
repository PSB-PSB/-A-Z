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
							 
							 
							 <!-- 댓글 영역 -->
							<div class="row">
								<div class="col-lg-12">
									<div class="panel panel-default">
									<div class="panel-heading">
										<i class="fa fa-comments fa-fw"></i>Reply
										<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
									</div>
				
										<div class="panel-body">
											<ul class="chat">
												
											</ul>	
										</div>
									</div>
								</div> 	
							</div>	
							
							<!-- Modal -->
                            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                                        </div>
                                        <div class="modal-body">
                                            <div class="form-group">
                                            	<label>Reply</label>
                                            	<input class="form-control" name="reply" value='New Reply'>
                                            </div>
                                            <div class="form-group">
                                            	<label>Replyer</label>
                                            	<input class="form-control" name='replyer' value='replyer'>
                                            </div>
                                            <div class="form-group">
                                            	<label>Reply data</label>
                                            	<input class="form-control" name='replydata' value=''>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button id="modalModBtn" type="button" class="btn btn-warning" data-dismiss="modal">modify</button>
                                            <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                                            <button id="modalRegisterBtn" type="button" class="btn btn-primary" data-dismiss="modal">Register</button>
                                            <button id="modalCloseBtn" type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                    <!-- /.modal-content -->
                                </div>
                                <!-- /.modal-dialog -->
                            </div>
                            <!-- /.modal -->
                            
                            <script type="text/javascript" src="/resources/js/reply.js"></script>
                            
                            <script type="text/javascript">
                            	
                            console.log("==========");
                            console.log("JS 테스트");
                            
                            
                            
                            $(document).ready(function(){
                            	var bnoValue = '<c:out value="${board.bno}"/>';
	                            var replyUL = $(".chat");
	                            
	                            showList(1);
	                            
	                            function showList(page){
	                                replyService.getList({bno:bnoValue,page: page||1}, function(list){

	                                    var str="";
	                                    if(list == null || list.length == 0){
	                                        replyUL.html("");

	                                        return
	                                    }
	                                    for(var i = 0, len = list.length||0; i < len; i++){
	                                    	str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	                                        str += "<div><div class='geader'><strong class='primary-font'>"+list[i].replyer+"</strong>";
	                                        str += "<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
	                                        str += "	<p>"+list[i].reply+"</p></div></li>";
	                                    }
	                                    replyUL.html(str);
	                                }); //end function
	                            }//end showList
	                            
	                            var modal = $(".modal");
	                            var modalInputReply = modal.find("input[name='reply']");
	                            var modalInputReplyer = modal.find("input[name='replyer']");
	                            var modalInputReplydata = modal.find("input[name='replydata']");
	                            
	                            var modalModBtn = $('#modalModBtn');
	                            var modalRemoveBtn = $("#modalRemoveBtn");
	                            var modalRegisterBtn = $("#modalRegisterBtn");
	                            
	                            $("#addReplyBtn").on("click", function(e){
	                            	modal.find('input').val("");
	                            	modalInputReplydata.closest("div").hide();
	                            	modal.find("button[id !='modalCloseBtn']").hide();
	                            	
	                            	modalRegisterBtn.show();
	                            	
	                            	$(".modal").modal("show");
	                            	
	                            modalRegisterBtn.on("click", function(e){
	                            	var reply = {
	                            			reply: modalInputReply.val(),
	                            			replyer: modalInputReplyer.val(),
	                            			bno:bnoValue
	                            	};
	                            	replyService.add(reply, function(result){
	                            		alert(result);
	                            	modal.find("input").val("");
	                            	modal.modal("hide");
	                            	
	                            	showList(1);
	                            	})
	                            });
	                            });
	                            
	                            $(".chat").on("click", "li", function(e){
	                            	var rno = $(this).data("rno");
	                            	
	                            	console.log(rno);
	                            	replyService.get(rno, function(reply){
	                            		modalInputReply.val(reply.reply);
	                            		modalInputReplyer.val(reply.replyer);
	                            		modalInputReplydata.val(replyService.displayTime(reply.replyDate))
	                            		.attr("readonly","readonly");
	                            		modal.data("rno",reply.rno);
	                            		
	                            		modal.find("button[id !='modalCloseBtn']").hide();
	                            		modalModBtn.show();
	                            		modalRemoveBtn.show();
	                            		
	                            		$(".modal").modal("show");
	                            	});
	                            });
	                            
	                            modalModBtn.on("click", function(e){
	                            	var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
	                            	
	                            	replyService.updata(reply, function(result){
	                            		alert(result);
	                            		modal.modal("hide");
	                            		showList(1);
	                            	});
	                            });
	                            
	                            modalRemoveBtn.on("click", function(e){
	                            	
	                            	var rno = modal.data("rno");
	                            	replyService.remove(rno, function(result){
	                            		alert(result);
	                            		modal.modal("hide");
	                            		showList(1);
	                            	});
	                            });
	                            
	                            
                            
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
