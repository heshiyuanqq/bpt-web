package com.cmri.bpt.web.login;

import java.io.PrintWriter;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.cmri.bpt.common.base.Result;
import com.cmri.bpt.common.base.Result.Type;
import com.cmri.bpt.common.user.UserContext;
import com.cmri.bpt.common.user.UserContextHolder;
import com.cmri.bpt.service.user.ProvinceService;
import com.cmri.bpt.service.user.UserService;
import com.cmri.bpt.service.user.bo.Province;
import com.cmri.bpt.service.user.bo.Select2Domain;
import com.cmri.bpt.service.user.bo.User;

@Controller
public class LoginController {

	@Autowired
	private ProvinceService provinceService;
	@Autowired
	private UserService userService;

	@RequestMapping("/index")
	public String index(Model model, HttpServletRequest request) {
		User user = (User) request.getSession().getAttribute("user");
		if (user != null) {
			return "index";
		} else {
			return "login";
		}
	}

	@RequestMapping(value = "/queryParentProvinces", method = RequestMethod.POST)
	public void queryParentProvinces(HttpServletRequest request, HttpServletResponse response) throws Exception {
		response.setCharacterEncoding("UTF-8");
		PrintWriter printWriter = response.getWriter();
		List<Select2Domain> lst = provinceService.queryParentProvinces();
		printWriter.write(JSON.toJSONString(lst));
		printWriter.flush();
		printWriter.close();
	}

	@RequestMapping(value = "/queryCityByProId", method = RequestMethod.POST)
	public void queryCityByProId(HttpServletRequest request, HttpServletResponse response, Long id) throws Exception {
		response.setCharacterEncoding("UTF-8");
		PrintWriter printWriter = response.getWriter();
		List<Select2Domain> lst = provinceService.queryCityByProId(id);
		System.out.println(id + "-->" + lst.size());
		printWriter.write(JSON.toJSONString(lst));
		printWriter.flush();
		printWriter.close();
	}

	@RequestMapping(value = "/registerUser", method = RequestMethod.POST)
	public String registerUser(User user, HttpServletRequest request, HttpServletResponse response) throws Exception {

		response.setCharacterEncoding("UTF-8");
		PrintWriter printWriter = response.getWriter();
		// 查询账户是否存在
		try {
			int i = userService.insertUser(user);
			printWriter.write("" + i);// 注册失败
		} catch (Exception e) {
			e.printStackTrace();
			printWriter.write("5");// 注册失败
		} finally {
			printWriter.flush();
			printWriter.close();
		}
		return null;
	}

	@RequestMapping("/login")
	public String login(Model model, HttpServletRequest request, String username, String password) {

		if (username == null && password == null) {
			User user = (User) request.getSession().getAttribute("user");
			if (user != null && user.getId() > 0) {
				return "index";
			} else {
				return "login";
			}

		}

		Result<User> userResult = userService.login(username, password);

		if (userResult.type == Type.warn) {
			model.addAttribute("errorType", "1");
			return "login";

		} else {
			request.getSession().setAttribute("user", userResult.data);
			return "index";
		}
	}

	@RequestMapping("/logout")
	@ResponseBody
	public String logout(Model model, HttpServletRequest request) {
		request.getSession().removeAttribute("user");
		request.getSession().removeAttribute(UserContextHolder.SESSION_KEY_USER_CONTEXT);
		UserContext userContext = UserContextHolder.getUserContext();
		userContext.clear();
		userContext = UserContextHolder.loadUserInfoIntoContext();
		return null;
	}

	@RequestMapping("/changepwd")
	@ResponseBody
	public Result changePwd(HttpServletRequest request) {

		String newpass = request.getParameter("newPassword");
		UserContext userContext = UserContextHolder.getUserContext();
		User user = userService.selectUserById(userContext.getUserId());
		userService.updatePassword(user, newpass);

		Result result = Result.newOne();

		result.type = Type.info;

		return result;
	}
	
	/**
	 * 检查当前用户密码是否正确
	 * @param request
	 * @return
	 */
	@RequestMapping("/checkPassword")
	@ResponseBody
	public Result checkPassword(HttpServletRequest request) {
		String oldPassword = request.getParameter("oldPassword");
		UserContext userContext = UserContextHolder.getUserContext();
		User user = userService.selectUserById(userContext.getUserId());
		
		boolean flag = userService.checkPassword(user,oldPassword);
		Result result = Result.newOne();
		if(flag){
			result.type = Type.info;
		}else{
			result.type = Type.unknown;
		}
		return result;
	}

}
