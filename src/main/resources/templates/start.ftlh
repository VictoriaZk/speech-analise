<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <title>Voice comments</title>
</head>
<body>
<div style="padding-left: 20px; padding-top: 10px">
    <span id="indicator">o</span>
    <button id="start">Start</button>
    <button id="stop">Stop</button>
    <select id="language">
        <option value="ru-RU" selected>Русский</option>
        <option value="en-US">Немецкий</option>
    </select>
</div>

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
                document.querySelector('#indicator').removeAttribute('style');
                document.querySelector('#indicator').setAttribute('style', 'width=10px; color: red;');

                mediaRecorder.start();
            });

            mediaRecorder.addEventListener("dataavailable", function(event) {
                voice.push(event.data);
            });

            document.querySelector('#stop').addEventListener('click', function(){
                document.querySelector('#indicator').removeAttribute('style');
                document.querySelector('#indicator').setAttribute('style', 'width=10px; color: green;');

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
