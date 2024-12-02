import defaultTheme from 'tailwindcss/defaultTheme';

/** @type {import('tailwindcss').Config} */
export default {
	safelist: [
		'bg-red-500',
	  ],
    content: [
		'./storage/framework/views/*.php',
        './resources/**/*.blade.php',
        './resources/**/*.js',
        './resources/**/*.vue',
		'./vendor/laravel/framework/src/Illuminate/Pagination/resources/views/*.blade.php',
    ],
    theme: {
        extend: {
            fontFamily: {
				sans: [
					'Plus Jakarta Sans',
					...defaultTheme.fontFamily.sans
				  ],
            },
			colors : {
				primary : '#0177BE',
				lightBlue : '#E0EFF9',
				primaryGreen : '#A1CC3A',
				grey : 'hsla(0, 0%, 27%, 0.1)',
				black : '#3C3C3C',
				lightGrey : '#B5B5B5',
			}
        },
    },
	
    plugins: [
	],
};
