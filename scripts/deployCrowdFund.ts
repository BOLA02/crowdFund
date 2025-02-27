import { toNano } from '@ton/core';
import { CrowdFund } from '../wrappers/CrowdFund';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const crowdFund = provider.open(await CrowdFund.fromInit());

    await crowdFund.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(crowdFund.address);

    // run methods on `crowdFund`
}
