package com.cmri.bpt.web.avatarSettings.web.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Controller
@RequestMapping("/webContravatarSettings")
public class AvatarSettingsController {

	private static final Logger logger = LoggerFactory.getLogger(AvatarSettingsController.class);

	
	@RequestMapping(method = RequestMethod.GET)
    public String index(Model model) {
        return "avatarSettings/indexFlash";
    }
	
	@RequestMapping(value="/xiuxiu",method = RequestMethod.GET)
    public String indexXiuXiu(Model model) {
        return "avatarSettings/index";
    }
}
