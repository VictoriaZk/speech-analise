package com.example.speechanalise.controller;

import com.example.speechanalise.service.VoiceMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/audio")
@RequiredArgsConstructor
public class VoiceController {
    private final VoiceMessageService voiceMessageService;

    @PostMapping()
    public String getAudio(@RequestParam("voice") MultipartFile voice,
                           @RequestParam("language") String language,
                           Model model) throws IOException {

        //model.addAttribute("analyze", voiceMessageService.voiceToMessage(voice.getBytes(), language));

        return voiceMessageService.voiceToMessage(voice.getBytes(), language);
    }
}
