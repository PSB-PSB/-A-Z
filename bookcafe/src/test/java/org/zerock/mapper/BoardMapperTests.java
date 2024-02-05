package org.zerock.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Test
	public void testGetList() {
		mapper.getList().forEach(board -> log.info(board));
	}
	
	@Test
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("Test 테스트");
		board.setContent("Content 테스트");
		board.setWriter("tester");
		
		mapper.insert(board);
		
	}
	@Test
	public void testInsertSelectKey() {
		BoardVO board = new BoardVO();
		board.setTitle("AAATest 테스트");
		board.setContent("AAAContent 테스트");
		board.setWriter("AAAtester");
		
		mapper.insertSelectkey(board);
		
		log.info("--------------------");
		log.info(" insert select key " + board.getBno());
		
		
	}
	@Test
	public void testRead() {
		BoardVO board = mapper.read(5L);
		
		log.info(board);
	}
	@Test
	public void testDelete() {
		log.info("DELETE CONT : " + mapper.delete(5L));
	}
	
	@Test
	public void testUpdate() {
		BoardVO board = new BoardVO();
		
		board.setBno(10L);
		board.setTitle("수정된 제목 테스트");
		board.setContent("수정된 내용 테스트");
		board.setWriter("수정된 유저 테스트");
		
		int count = mapper.update(board);
		log.info("UPDATE COUNT : " + count);
	}
	
	@Test
	public void testPaging() {
		//1페이지 10개 (1,10)
		Criteria cri = new Criteria();
		
		List<BoardVO> list = mapper.getListWithPageing(cri);
		
		list.forEach(b -> log.info(b));
		
	}
	
	@Test
	public void testpageDTO() {
		Criteria cri = new Criteria();
		
		cri.setPageNum(21);
		
		PageDTO pageDTO = new PageDTO(cri, 250);
		
		log.info(pageDTO);
		
	}
	
	@Test
	public void testSearch() {
		Map<String, String> map = new HashMap<>();
		map.put("T", "TTT");
		map.put("C", "CCC");
		map.put("W", "WWW");
		
		Map<String, Map<String, String>> outer = new HashMap<>();
		outer.put("map", map);
		
		List<BoardVO> list = mapper.searchTest(outer);
		
		log.info(list);
	}
	
	@Test
	public void testSearchPaging() {
		Criteria cri = new Criteria();
		cri.setType("TCW");
		cri.setKeyword("Test");
		List<BoardVO> list = mapper.getListWithPageing(cri);
		
		list.forEach(b -> log.info(b));
		
	}
}
