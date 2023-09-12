// Learn more about noise and scaling from the Private Aggregation fundamentals
// documentation on Chrome blog
const SCALE_FACTOR = 65536;

/**
 * The bucket key must be a number, and in this case, it is simply the content
 * ID itself. For more complex bucket key construction, see other use cases in
 * this demo.
 */
function convertContentIdToBucket(contentId) {
    return BigInt(contentId);
}

class KFreqMeasurementOperation {
    async run(data) {
        console.log("Methods available in the sharedStorage worklet:");
        let props = [];
        if (typeof window !== "undefined") {
            for (prop in window) {
                props.push(prop);
            }
            props.sort();
            console.log(`Window: ${props.join("(), ")}()`);
            if (typeof window.sharedStorage !== "undefined") {
                props = [];
                for (prop in window.sharedStorage) {
                    props.push(prop);
                }
                props.sort();
                console.log(`window.sharedStorage: ${props.join("(), ")}()`);
            }
            if (typeof window.fence !== "undefined") {
                props = [];
                for (prop in window.fence) {
                    props.push(prop);
                }
                props.sort();
                console.log(`window.fence: ${props.join("(), ")}()`);
            }
        }
        if (typeof navigator !== "undefined") {
            props = [];
            for (prop in navigator) {
                props.push(prop);
            }
            props.sort();
            console.log(`Navigator: ${props.join("(), ")}()`);
        }
        if (typeof document !== "undefined") {
            props = [];
            for (prop in document) {
                props.push(prop);
            }
            props.sort();
            console.log(`Document: ${props.join("(), ")}()`);
        }
        if (typeof this !== "undefined") {
            props = [];
            for (prop in this) {
                props.push(prop);
            }
            props.sort();
            console.log(`This: ${props.join("(), ")}()`);
        }

        const { kFreq, contentId } = data;

        // Read from Shared Storage
        const hasReportedContentKey = 'has-reported-content';
        const impressionCountKey = 'impression-count';
        const hasReportedContent = (await this.sharedStorage.get(hasReportedContentKey)) === 'true';
        const impressionCount = parseInt((await this.sharedStorage.get(impressionCountKey)) || 0);

        // Do not report if a report has been sent already
        if (hasReportedContent) {
            return;
        }

        // Check impression count against frequency limit
        if (impressionCount < kFreq) {
            await this.sharedStorage.set(impressionCountKey, impressionCount + 1);
            return;
        }

        // Generate the aggregation key and the aggregatable value
        const bucket = convertContentIdToBucket(contentId);
        const value = 1 * SCALE_FACTOR;

        // Send an aggregatable report via the Private Aggregation API
        privateAggregation.sendHistogramReport({ bucket, value });

        // Set the report submission status flag
        await this.sharedStorage.set(hasReportedContentKey, 'true');
    }
}

// Register the operation
register('k-freq-measurement', KFreqMeasurementOperation);
