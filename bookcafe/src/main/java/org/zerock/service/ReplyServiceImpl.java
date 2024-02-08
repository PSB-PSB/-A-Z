package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
 

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService{

	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;
	
	@Override
	public int register(ReplyVO reply) {
		
		log.info("register..." + reply);
		return mapper.insert(reply);
	}

	@Override
	public ReplyVO get(Long rno) {
		
		log.info("get...." + rno);
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO reply) {
		
		log.info("modify..." + reply);
		return mapper.update(reply);
	}

	@Override
	public int remove(Long rno) {
		log.info("remove...." + rno);
		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		
		log.info("get Reply List of a Board" + bno);
		return mapper.getListWithPaging(cri, bno);
	}

}
