package org.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	// 해달 번호가 게시물이 존재하는지 확인해야함.
	private Long[] bnoArr = { 2461L, 2460L , 2459L, 2458L, 2457L};
	
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Test
	public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i ->{
			ReplyVO reply = new ReplyVO();
			
			//게시물 번호			
			reply.setBno(bnoArr[i % 5]);
			reply.setReply("댓글 테스트" + i);
			reply.setReplyer("댓글 작성자" + i);
			mapper.insert(reply);
		});
	}
	
	@Test
	public void testRead() {
		Long targetRno = 5L;
		
		ReplyVO reply = mapper.read(targetRno);
		
		log.info(reply);
	}
	
	@Test
	public void testDelete() {
		Long targetRno = 1L;
		
		mapper.delete(targetRno);
	}
	
	
	@Test
	public void testUpdate() {
		Long targetRno = 10L;
		
		ReplyVO reply = mapper.read(targetRno);
		
		reply.setReply("수정 댓글");
		
		int count = mapper.update(reply);
		
		log.info("업데이트 카운트 " + count);
	}
	
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		
		//2461L
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testList2() {
		Criteria cri = new Criteria(2, 10);
		List<ReplyVO> replies = mapper.getListWithPaging(cri, 2461L);
		
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testMapper() {
		log.info(mapper);
	}

}
