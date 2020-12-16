<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Voice comments</title>
</head>
<body>
<h3 id="indicator">Запись не ведётся</h3>
<br>
<div style="padding-left: 20px; padding-top: 10px">
    <button id="start">Start</button>
    <button id="stop">Stop</button>
    <select id="language">
        <option value="en-US" selected>Английский</option>
        <option value="de-DE">Немецкий</option>
    </select>
</div>
<br>

<#if analyze??>
    <div style="padding: 20px; border: 2px solid black">
        ${analyze}
    </div>
</#if>
</body>

<script>
    navigator.mediaDevices.getUserMedia({ audio: true})
        .then(stream => {
            const mediaRecorder = new MediaRecorder(stream);
            let voice = [];

            document.querySelector('#start').addEventListener('click', function(){
                debugger;
                document.querySelector('#indicator').value = "Ведётся запись...";

                mediaRecorder.start();
            });

            mediaRecorder.addEventListener("dataavailable", function(event) {
                voice.push(event.data);
            });

            document.querySelector('#stop').addEventListener('click', function(){
                document.querySelector('#indicator').value = "Запись не ведётся";

                mediaRecorder.stop();
            });

            mediaRecorder.addEventListener("stop", async function() {
                const voiceBlob = new Blob(voice, {
                    type: 'audio/wav'
                });

                let fd = new FormData();
                fd.append('voice', voiceBlob);
                fd.append('language', document.querySelector('#language').value);

                let promise = await fetch("http://localhost:8080/audio", {
                    method: 'POST',
                    body: fd})
                .then(response => {
                    response.body;
                    debugger;
                });
            });
        });

</script>
</html>
