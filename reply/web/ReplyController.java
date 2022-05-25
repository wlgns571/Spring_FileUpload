package com.study.reply.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.exception.BizAccessFailException;
import com.study.exception.BizNotFoundException;
import com.study.reply.service.IReplyService;
import com.study.reply.vo.ReplySearchVO;
import com.study.reply.vo.ReplyVO;

@Controller
public class ReplyController {
	@Inject
	IReplyService replyService;
	
	@ResponseBody
	@RequestMapping(value = "/reply/replyList.wow", produces = "application/json; charset = utf-8")
	public List<ReplyVO> replyList(ReplySearchVO searchVO){
		List<ReplyVO> replyList = replyService.getReplyListByParent(searchVO);
		return replyList;
	}
	
	@ResponseBody
	@RequestMapping(value = "/reply/replyRegist.wow", produces = "application/json; charset = utf-8")
	public Map<String,Object> replyRegist(ReplyVO reply){
		replyService.registReply(reply);
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("data", "DB등록완");
		map.put("success", true);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/reply/replyModify.wow", produces = "application/json; charset = utf-8")
	public Map<String, Object> replyModify(ReplyVO reply) throws BizNotFoundException, BizAccessFailException{
		replyService.modifyReply(reply);
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("data", "DB수정완");
		map.put("success", true);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/reply/replyDelete.wow", produces = "application/json; charset = utf-8")
	public Map<String, Object> replyDelete(ReplyVO reply) throws BizNotFoundException, BizAccessFailException{
		replyService.removeReply(reply);
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("data", "DB삭제완");
		map.put("success", true);
		return map;
	}
	
	
	
}
