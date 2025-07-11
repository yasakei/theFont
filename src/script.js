document.addEventListener('DOMContentLoaded', function() {
    // Terminal typing animation
    const terminalText = document.getElementById('terminal-text');
    const command = 'tf https://www.dafont.com/super-adorable.font';
    let i = 0;

    function typeWriter() {
        if (i < command.length) {
            terminalText.innerHTML += command.charAt(i);
            i++;
            setTimeout(typeWriter, 100);
        }
    }
    
    setTimeout(typeWriter, 1000); // Start typing after a short delay

    // Copy button functionality
    const copyButton = document.getElementById('copy-button');
    const codeBlock = document.querySelector('.code-block code');

    copyButton.addEventListener('click', () => {
        const textToCopy = codeBlock.innerText;
        navigator.clipboard.writeText(textToCopy).then(() => {
            copyButton.innerText = 'Copied!';
            setTimeout(() => {
                copyButton.innerText = 'Copy';
            }, 2000);
        }).catch(err => {
            console.error('Failed to copy text: ', err);
        });
    });
});
