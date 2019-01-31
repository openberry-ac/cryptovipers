// This should have been deployed to Remix
// We will be using Solidity version 0.5.3
pragma solidity 0.5.3;
// Importing OpenZeppelin's ERC-721 Implementation
import 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
// Importing OpenZeppelin's SafeMath Implementation
import 'https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol';


contract ViperToken is ERC721Full {
    using SafeMath for uint256;
    // This struct will be used to represent one viper
    struct Viper {
        uint8 genes;
        uint256 matronId;
        uint256 sireId;
    }
    
    // List of existing vipers
    Viper[] public vipers;

    // Event that will be emitted whenever a new viper is created
    event Birth(
        address owner,
        uint256 viperId,
        uint256 matronId,
        uint256 sireId,
        uint8 genes
    );

    // Initializing an ERC-721 Token named 'Vipers' with a symbol 'VPR'
    constructor() ERC721Full("Vipers", "VPR") public {
    }

    // Fallback function
    function() external payable {
    }

    /** @dev Function to determine a viper's characteristics.
      * @param matron ID of viper's matron (one parent)
      * @param sire ID of viper's sire (other parent)
      * @return The viper's genes in the form of uint8
      */
    function generateViperGenes(
        uint256 matron,
        uint256 sire
    )
        internal
        pure
        returns (uint8)
    {
        return uint8(matron.add(sire)) % 6 + 1;
    }

    /** @dev Function to create a new viper
      * @param matron ID of new viper's matron (one parent)
      * @param sire ID of new viper's sire (other parent)
      * @param viperOwner Address of new viper's owner
      * @return The new viper's ID
      */
    function createViper(
        uint256 matron,
        uint256 sire,
        address viperOwner
    )
        internal
        returns (uint)
    {
        require(viperOwner != address(0));
        uint8 newGenes = generateViperGenes(matron, sire);
        Viper memory newViper = Viper({
            genes: newGenes,
            matronId: matron,
            sireId: sire
        });
        uint256 newViperId = vipers.push(newViper).sub(1);
        super._mint(viperOwner, newViperId);
        emit Birth(
            viperOwner,
            newViperId,
            newViper.matronId,
            newViper.sireId,
            newViper.genes
        );
        return newViperId;
    }
    
    /** @dev Function to allow user to buy a new viper (calls createViper())
      * @return The new viper's ID
      */
    function buyViper() external payable returns (uint256) {
        require(msg.value == 0.02 ether);
        return createViper(0, 0, msg.sender);
    }
    
    /** @dev Function to breed 2 vipers to create a new one
      * @param matronId ID of new viper's matron (one parent)
      * @param sireId ID of new viper's sire (other parent)
      * @return The new viper's ID
      */
    function breedVipers(uint256 matronId, uint256 sireId) external payable returns (uint256) {
        require(msg.value == 0.05 ether);
        return createViper(matronId, sireId, msg.sender);
    }
    
    /** @dev Function to retrieve a specific viper's details.
      * @param viperId ID of the viper who's details will be retrieved
      * @return An array, [viper's ID, viper's genes, matron's ID, sire's ID]
      */
    function getViperDetails(uint256 viperId) external view returns (uint256, uint8, uint256, uint256) {
        Viper storage viper = vipers[viperId];
        return (viperId, viper.genes, viper.matronId, viper.sireId);
    }
    
    /** @dev Function to get a list of owned vipers' IDs
      * @return A uint array which contains IDs of all owned vipers
      */
    function ownedVipers() external view returns(uint256[] memory) {
        uint256 viperCount = balanceOf(msg.sender);
        if (viperCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](viperCount);
            uint256 totalVipers = vipers.length;
            uint256 resultIndex = 0;
            uint256 viperId = 0;
            while (viperId < totalVipers) {
                if (ownerOf(viperId) == msg.sender) {
                    result[resultIndex] = viperId;
                    resultIndex = resultIndex.add(1);
                }
                viperId = viperId.add(1);
            }
            return result;
        }
    }
}
