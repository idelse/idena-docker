const app = require("express")();
const proxy = require("express-http-proxy");
const cors = require("cors");
const fs = require("fs");

const key = fs.readFileSync("/home/idena/datadir/api.key", "utf-8");

function tryParseJSON (rawJson) {
    try {
        const object = JSON.parse(rawJson);
        if (object && typeof object === "object")
            return object;
    }
    catch (e) {}
    return false;
};

app.use(cors());

app.use(proxy("http://localhost:9009", {
    proxyReqBodyDecorator: (bodyContent) => {
        const body = tryParseJSON(bodyContent);
        if (body) {
            return {
                ...body,
                key,
            };
        }
        return "";
    },
}));

app.listen(80);
