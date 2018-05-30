package controller;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import model.User;
import service.UserService;

@Controller
public class UserController {
@Autowired
private UserService userService;
@RequestMapping("/index")
public ModelAndView getIndex(){
	 ModelAndView mav = new ModelAndView("index"); 
     User user = userService.selectuser(1); 
     mav.addObject("user", user); 
     return mav; 
}
}
