import { CompilerConfig } from '@ton/blueprint';

export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/crowd_fund.tact',
    options: {
        debug: true,
    },
};
