package com.example.speechanalise.service;

import com.google.api.gax.longrunning.OperationFuture;
import com.google.cloud.speech.v1.*;
import com.google.protobuf.ByteString;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VoiceMessageService {
    public String voiceToMessage(byte[] bytes, String language) {
        try (SpeechClient speechClient = SpeechClient.create()) {
            ByteString audioBytes = ByteString.copyFrom(bytes);
            RecognitionConfig config =
                    RecognitionConfig.newBuilder()
                            .setEncoding(RecognitionConfig.AudioEncoding.OGG_OPUS)
                            .setEnableAutomaticPunctuation(true)
                            .setEnableAutomaticPunctuation(true)
                            .setEnableWordTimeOffsets(true)
                            .setSampleRateHertz(48000)
                            .setLanguageCode(language)
                            .setModel("default")
                            .build();

            RecognitionAudio audio = RecognitionAudio.newBuilder().setContent(audioBytes).build();
            OperationFuture<LongRunningRecognizeResponse, LongRunningRecognizeMetadata> response =
                    speechClient.longRunningRecognizeAsync(config, audio);

            StringBuilder recognizedMessage = new StringBuilder();

            while (!response.isDone()) {
                Thread.sleep(1000);
            }
            List<SpeechRecognitionResult> resultsList = response.get().getResultsList();


            for (SpeechRecognitionResult result : resultsList) {
                SpeechRecognitionAlternative alternative = result.getAlternativesList().get(0);
                recognizedMessage.append(alternative.getTranscript());
            }

            return recognizedMessage.toString();
        } catch (Exception e) {
            return "";
        }
    }
}
