// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

import {AxelarExecutable} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/executables/AxelarExecutable.sol";
import {IAxelarGateway} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGateway.sol";
import {IAxelarGasService} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IAxelarGasService.sol";
import {IERC20} from "@axelar-network/axelar-gmp-sdk-solidity/contracts/interfaces/IERC20.sol";

contract PolygonSender is AxelarExecutable {
    string public functionSent;
    string public parametersSent;
    string public sourceChain;
    string public sourceAddress;
    //this is because once deployed it should remain fairly stable and no need to be passing it with every call
    string public distinationAddress;
    address private admin;
    IAxelarGasService public immutable gasReceiver;

    constructor(address gateway_, address gasReceiver_)
        AxelarExecutable(gateway_)
    {
        gasReceiver = IAxelarGasService(gasReceiver_);
        admin = msg.sender;
    }

    modifier isAdmin() {
        require(admin == msg.sender);
        _;
    }

    function moonbeamContractAddressSetter(string calldata destinationAddress_)
        public
        isAdmin
    {
        distinationAddress = destinationAddress_;
    }

    // Call this function to update the value of this contract along with all its siblings'.
    function mintStamp(string calldata stampURI_) external payable {
        bytes memory payload = abi.encode(
            "mintStamp(address, string)",
            stampURI_,
            msg.sender
        );
        sendCall(payload);
    }

    function mintLetterbox(string calldata stampURI_) external payable {
        bytes memory payload = abi.encode(
            "mintLetterbox(address, string)",
            stampURI_,
            msg.sender
        );
        sendCall(payload);
    }

    function letterboxList() external payable {}

    function sendCall(bytes memory payload_) internal {
        if (msg.value > 0) {
            gasReceiver.payNativeGasForContractCall{value: msg.value}(
                address(this),
                "Moonbeam",
                distinationAddress,
                payload_,
                msg.sender
            );
        }
        gateway.callContract("Moonbeam", distinationAddress, payload_);
    }

    // Handles calls created by setAndSend. Updates this contract's value
    function _execute(
        string calldata sourceChain_,
        string calldata sourceAddress_,
        bytes calldata payload_
    ) internal override {
        (functionSent, parametersSent) = abi.decode(payload_, (string, string));
        sourceChain = sourceChain_;
        sourceAddress = sourceAddress_;
    }
}
