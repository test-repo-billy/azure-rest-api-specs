"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.printers = exports.parsers = exports.languages = void 0;
const prettier_1 = require("prettier");
const parser_babel_1 = require("prettier/parser-babel");
const { concat, indent, hardline, join } = prettier_1.doc.builders;
// Modified from https://github.com/prettier/prettier/blob/master/src/language-js/printer-estree-json.js
const print = (path, _, print) => {
    const node = path.getValue();
    switch (node.type) {
        case "JsonRoot":
            return concat([path.call(print, "node"), hardline]);
        case "ArrayExpression":
            return node.elements.length === 0
                ? "[]"
                : concat([
                    "[",
                    indent(concat([
                        hardline,
                        join(concat([",", hardline]), path.map(print, "elements"))
                    ])),
                    hardline,
                    "]"
                ]);
        case "ObjectExpression":
            return node.properties.length === 0
                ? "{}"
                : concat([
                    "{",
                    indent(concat([
                        hardline,
                        join(concat([",", hardline]), path.map(print, "properties"))
                    ])),
                    hardline,
                    "}"
                ]);
        case "ObjectProperty":
            return concat([path.call(print, "key"), ": ", path.call(print, "value")]);
        case "UnaryExpression":
            return concat([
                node.operator === "+" ? "" : node.operator,
                path.call(print, "argument")
            ]);
        case "NullLiteral":
            return "null";
        case "BooleanLiteral":
            return node.value ? "true" : "false";
        case "StringLiteral":
            return JSON.stringify(node.value);
        case "NumericLiteral":
            // Modified: Keep numeric literal as-is
            return node.extra.raw;
        case "Identifier":
            return JSON.stringify(node.name);
        default:
            /* istanbul ignore next */
            throw new Error("unknown type: " + JSON.stringify(node.type));
    }
};
const preprocess = (ast, _) => {
    return Object.assign({}, ast, {
        type: "JsonRoot",
        node: ast,
        comments: []
    });
};
exports.languages = [
    {
        name: 'json-swagger',
        extensions: ['.json'],
        parsers: ['json-swagger']
    }
];
exports.parsers = {
    'json-swagger': {
        ...parser_babel_1.parsers['json-stringify'],
        astFormat: 'estree-swagger-customized'
    }
};
exports.printers = {
    'estree-swagger-customized': {
        preprocess,
        print
    }
};
//# sourceMappingURL=prettier-swagger-plugin.js.map