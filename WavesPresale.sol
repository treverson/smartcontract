/* 
 source code generate by Bui Dinh Ngoc aka ngocbd<buidinhngoc.aiti@gmail.com> for smartcontract WavesPresale at 0xAE506bb28Ed79b29c6968Ab527d1eFdc5f399331
*/
contract WavesPresale {
    address public owner;
    
    struct Sale
    {
        uint amount;
        uint date;
    }

    mapping (bytes16 => Sale[]) public sales;
    uint32 public numberOfSales;
    uint public totalTokens;

    function WavesPresale() {
        owner = msg.sender;
        numberOfSales = 0;
    }

    function changeOwner(address newOwner) {
        if (msg.sender != owner) return;

        owner = newOwner;
    }

    function newSale(bytes16 txidHash, uint amount, uint timestamp) {
        if (msg.sender != owner) return;

        sales[txidHash].push(Sale({
                    amount: amount,
                    date: timestamp
                }));
        numberOfSales += 1;
        totalTokens += amount;
    }

    function getNumOfSalesWithSameId(bytes16 txidHash) constant returns (uint) {
        return sales[txidHash].length;
    }

    function getSaleDate(bytes16 txidHash, uint num) constant returns (uint, uint) {
    	return (sales[txidHash][num].amount, sales[txidHash][num].date);
    }

    function () {
        // This function gets executed if a
        // transaction with invalid data is sent to
        // the contract or just ether without data.
        // We revert the send so that no-one
        // accidentally loses money when using the
        // contract.
        throw;
    }

}