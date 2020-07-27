#!/bin/bash

# Main
npx create-next-app $1 -e default --use-npm

cd $1

# Dependencies
## TypeScript
## Linting/Styles
## ESLint Rules
## TypeScript ESLint Rules
npm install --save-dev \
  typescript @types/react @types/node \
  eslint prettier \
  eslint-plugin-react eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react-hooks \
  @typescript-eslint/eslint-plugin @typescript-eslint/parser  

# TypeScript
touch tsconfig.json
echo "/* eslint-disable react/no-typos */
import 'react';

declare module 'react' {
  interface StyleHTMLAttributes<T> extends React.HTMLAttributes<T> {
    jsx?: boolean;
    global?: boolean;
  }
}
" > next-env.d.ts
mv ./pages/index.js ./pages/index.tsx
mv ./pages/api/hello.js ./pages/api/hello.ts

# Prettier
echo '{
  "bracketSpacing": false,
  "jsxBracketSameLine": true,
  "singleQuote": true,
  "trailingComma": "all",
  "arrowParens": "always"
}
' > .prettierrc
echo 'node_modules
.vscode
yarn-error.log
package-lock.json
yarn.lock
.gitignore
.prettierignore
.DS_Store
*.svg
*.png
*.ico
.github
.env
*.plist
*.sh
' > .prettierignore
#sed '7 a "pretty": "prettier \"./**/*\" --write",' package.json
prettier "./**/*" --write

# ESLint
# eslint --init # Manual installation
echo '{
  "env": {
    "browser": true,
    "es2020": true
  },
  "extends": [
    "plugin:@typescript-eslint/eslint-recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:react/recommended",
    "airbnb"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": 11,
    "sourceType": "module"
  },
  "plugins": [
    "react", 
    "@typescript-eslint"
  ],
  "rules": {
    "react/react-in-jsx-scope": "off",
    "react/jsx-filename-extension": [1, { "extensions": [".tsx"] }],
    "@typescript-eslint/no-empty-interface": "off"
  }
}
' > .eslintrc
echo './node_modules/*
' > .eslintignore
#sed '7 a "lint": "eslint . --ext .ts,.tsx",' package.json
#sed '8 a "lint:fix": "eslint . --ext .ts,.tsx --fix",' package.json
eslint . --ext .ts,.tsx --fix

# Clean
cd -

echo "Installation complete. To finalize configuration, execute the development server once:
cd $1 && npm run dev"
