async function injectContent() {
    // Load the Shared Storage worklet
    await window.sharedStorage.worklet.addModule('k-freq-measurement-worklet.js');

    // Run the K-frequency measurement operation
    await window.sharedStorage.run('k-freq-measurement', { data: { kFreq: 3, contentId: 123 }});
}

injectContent();

