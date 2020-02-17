const path = require('path');

module.exports = {
	entry: './src/index.js',
	output: {
		filename: 'main.js',
		path: path.resolve(__dirname, 'public', 'js'),
	},
	module: {
		rules: [
		{
			test: /\.css$/,
			use: [
			'style-loader',
			'css-loader',
			],
		},
		],
	},
};