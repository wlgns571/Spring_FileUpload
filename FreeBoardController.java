package com.study.free.web;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.validation.groups.Default;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.study.code.service.CommCodeServiceImpl;
import com.study.code.service.ICommCodeService;
import com.study.code.vo.CodeVO;
import com.study.common.util.StudyAttachUtils;
import com.study.common.valid.Modify;
import com.study.common.vo.ResultMessageVO;
import com.study.exception.BizNotEffectedException;
import com.study.exception.BizNotFoundException;
import com.study.exception.BizPasswordNotMatchedException;
import com.study.free.service.FreeBoardServiceImpl;
import com.study.free.service.IFreeBoardService;
import com.study.free.vo.FreeBoardSearchVO;
import com.study.free.vo.FreeBoardVO;

@Controller
public class FreeBoardController {
	@Inject
	IFreeBoardService freeBoardService;
	@Inject
	ICommCodeService codeService;
	

	@ModelAttribute("cateList")
	public List<CodeVO> cateList() {
		return codeService.getCodeListByParent("BC00");
	}

	@RequestMapping(value = "/free/freeList.wow")
	public String freeBoardList(Model model, @ModelAttribute("SearchVO") FreeBoardSearchVO searchVO) {
		List<FreeBoardVO> freeBoardList = freeBoardService.getBoardList(searchVO);
		model.addAttribute("freeBoardList", freeBoardList);


		return "free/freeList";
	}

	@RequestMapping("/free/freeView.wow")
	public String freeBoardView(Model model, @RequestParam(required = true, name = "boNo") int boNo) {
		try {
			FreeBoardVO freeBoard = freeBoardService.getBoard(boNo);
			model.addAttribute("freeBoard", freeBoard);
			freeBoardService.increaseHit(boNo);

		} catch (BizNotFoundException enf) {
			ResultMessageVO resultMessageVO = new ResultMessageVO();
			resultMessageVO.messageSetting(false, "???Notfound", "?????? ?????? ????????????", "/free/freeList.wow", "????????????");
			model.addAttribute("resultMessageVO", resultMessageVO);
			return "common/message";
		} catch (BizNotEffectedException ene) {
			ResultMessageVO resultMessageVO = new ResultMessageVO();
			resultMessageVO.messageSetting(false, "???NotEffected", "??????????????? ??????????????????", "/free/freeList.wow", "????????????");
			model.addAttribute("resultMessageVO", resultMessageVO);
			return "common/message";
		}
		return "free/freeView";
	}

	@RequestMapping("/free/freeEdit2.wow")
	public ModelAndView freeBoardEdit(int boNo) {
		ModelAndView mav = new ModelAndView();

		try {
			FreeBoardVO freeBoard = freeBoardService.getBoard(boNo);
			mav.addObject("freeBoard", freeBoard);
		} catch (BizNotFoundException enf) {
			ResultMessageVO resultMessageVO = new ResultMessageVO();
			resultMessageVO.messageSetting(false, "???Notfound", "?????? ?????? ????????????", "/free/freeList.wow", "????????????");
			mav.addObject("resultMessageVO", resultMessageVO);
			mav.setViewName("common/message");
		}

		mav.setViewName("free/freeEdit");

		return mav;

	}

	@RequestMapping("/free/freeEdit.wow")
	public String freeBoardEdit(Model model, int boNo) {
		try {
			FreeBoardVO freeBoard = freeBoardService.getBoard(boNo);
			model.addAttribute("freeBoard", freeBoard);
		} catch (BizNotFoundException enf) {
			ResultMessageVO resultMessageVO = new ResultMessageVO();
			resultMessageVO.messageSetting(false, "???Notfound", "?????? ?????? ????????????", "/free/freeList.wow", "????????????");
			model.addAttribute("resultMessageVO", resultMessageVO);
			return "common/message";
		}
		return "free/freeEdit";
	}

	@RequestMapping(value = "/free/freeModify.wow", method = RequestMethod.POST)
	
	public String freeBoardModify(Model model,@Validated(value = {Modify.class, Default.class}) @ModelAttribute("freeBoard") FreeBoardVO freeBoard, BindingResult error) {
		
		if(error.hasErrors()) {
			return "free/freeEdit";
		}
		
		ResultMessageVO resultMessageVO = new ResultMessageVO();

		try {
			freeBoardService.modifyBoard(freeBoard);
			resultMessageVO.messageSetting(true, "??????", "????????????", "/free/freeList.wow", "????????????");
		} catch (BizNotFoundException enf) {
			resultMessageVO.messageSetting(false, "???Notfound", "?????? ?????? ????????????", "/free/freeList.wow", "????????????");
		} catch (BizPasswordNotMatchedException epm) {
			resultMessageVO.messageSetting(false, "??????????????????", "???????????? ??????????????? ????????????", "/free/freeList.wow", "????????????");
		} catch (BizNotEffectedException ene) {
			resultMessageVO.messageSetting(false, "???NotEffected", "??????????????? ??????????????????", "/free/freeList.wow", "????????????");
		}
		model.addAttribute("resultMessageVO", resultMessageVO);
		return "common/message";
	}

	@PostMapping("/free/freeDelete.wow")
	public String freeBoardDelete(Model model, @ModelAttribute("freeBoard") FreeBoardVO freeBoard) {
		ResultMessageVO resultMessageVO = new ResultMessageVO();
		try {
			freeBoardService.removeBoard(freeBoard);
			resultMessageVO.messageSetting(true, "??????", "????????????", "/free/freeList.wow", "????????????");
		} catch (BizNotFoundException enf) {
			resultMessageVO.messageSetting(false, "???Notfound", "?????? ?????? ????????????", "/free/freeList.wow", "????????????");
		} catch (BizPasswordNotMatchedException epm) {
			resultMessageVO.messageSetting(false, "??????????????????", "???????????? ??????????????? ????????????", "/free/freeList.wow", "????????????");
		} catch (BizNotEffectedException ene) {
			resultMessageVO.messageSetting(false, "???NotEffected", "??????????????? ??????????????????", "/free/freeList.wow", "????????????");
		}
		model.addAttribute("resultMessageVO", resultMessageVO);
		return "common/message";
	}

	@RequestMapping("/free/freeForm.wow")
	public String freeBoardForm(Model model) {
		model.addAttribute("freeBoard", new FreeBoardVO()); 
		return "free/freeForm";
	}
	
	@Inject
	StudyAttachUtils studyAttachUtils;
	
	@PostMapping("/free/freeRegist.wow")
	public String freeBoardRegist(Model model
			,@Validated(value = Modify.class)@ModelAttribute("freeBoard") FreeBoardVO freeBoard
			, BindingResult error
			, @RequestParam(required = false)MultipartFile[] boFiles
			) throws IOException {
		if(error.hasErrors()) {
			return "free/freeForm";
		}
		if(boFiles != null) {
			studyAttachUtils.getAttachListByMultiparts(boFiles);
		}
		
		
		ResultMessageVO resultMessageVO=new ResultMessageVO();
		try {
			freeBoardService.registBoard(freeBoard);
			resultMessageVO.messageSetting(true, "??????", "????????????", "free/freeList.wow"
					 ,"????????????");
		} catch (BizNotEffectedException ebe) {
			resultMessageVO.messageSetting(false, "??????", "??????????????????", "free/freeList.wow"
					 ,"????????????");
		}
		model.addAttribute("resultMessageVO", resultMessageVO);
		return "common/message";
	}
	
	
}


