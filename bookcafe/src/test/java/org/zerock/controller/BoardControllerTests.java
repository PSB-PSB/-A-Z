package org.zerock.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.zerock.service.BoardService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
@Log4j
public class BoardControllerTests {
	
	
	@Setter(onMethod_ = { @Autowired })
	private WebApplicationContext ctx;
	
	//가짜로 Requset를 만들어서 보내는것.
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup((WebApplicationContext) ctx).build();
	}
	
	@Test
	public void testlist() throws Exception {
		log.info(
				mockMvc.perform(						
						MockMvcRequestBuilders.get("/board/list"))
				.andReturn()
				.getModelAndView()
				.getModelMap());
	}
	@Test
	public void testRegister() throws Exception {
		log.info(
				mockMvc.perform(						
						MockMvcRequestBuilders.post("/board/register")
						.param("title", "test 테스트")
						.param("Content", "Content")
						.param("Writer", "Wirter")
						)
				.andReturn());
	}
	
}
