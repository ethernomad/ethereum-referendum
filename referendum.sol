/**
 * @title Referendum
 * @author Jonathan Brown <jbrown@bluedroplet.com>
 */
contract Referendum {

    enum Vote { NotVoted, Yes, No, Retracted }

    string public title;
    bytes public wording;  // Brotlied Markdown
    string public uri;
    uint public startBlock;
    uint public endBlock;   // Hard fork would occur on this block

    address[] public voters;
    mapping (address => Vote) public votes;

    event logYes(address voter);
    event logNo(address voter);
    event logRetracted(address voter);

    function Referendum(string _title, bytes _wording, string _uri, uint _endBlock) {
        title = _title;
        wording = _wording;
        uri = _uri;
        startBlock = block.number;
        endBlock = _endBlock;
    }

    modifier referendumActive() {
        if (block.number < endBlock) {
            _
        }
    }

    modifier recordVoter() {
        if (votes[msg.sender] == Vote.NotVoted) {
            voters.push(msg.sender);
        }
        _
    }

    function voteYes() referendumActive recordVoter {
        votes[msg.sender] = Vote.Yes;
        logYes(msg.sender);
    }

    function voteNo() referendumActive recordVoter {
        votes[msg.sender] = Vote.No;
        logNo(msg.sender);
    }

    function unVote() referendumActive recordVoter {
        votes[msg.sender] = Vote.Retracted;
        logRetracted(msg.sender);
    }

    function getYesWeight() constant returns (uint weight) {
        for (uint i = 0; i < voters.length; i++) {
            address voter = voters[i];
            if (votes[voter] == Vote.Yes) {
                weight += voter.balance;
            }
        }
    }

    function getNoWeight() constant returns (uint weight) {
        for (uint i = 0; i < voters.length; i++) {
            address voter = voters[i];
            if (votes[voter] == Vote.No) {
                weight += voter.balance;
            }
        }
    }

    function getNetWeight() constant returns (int weight) {
        for (uint i = 0; i < voters.length; i++) {
            address voter = voters[i];
            if (votes[voter] == Vote.Yes) {
                weight += int(voter.balance);
            }
            else if (votes[voter] == Vote.No) {
                weight -= int(voter.balance);
            }
        }
    }

    function getResult() constant returns (bool) {
        return (getNetWeight() > 0);
    }

}
