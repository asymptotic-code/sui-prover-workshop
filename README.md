# Move Prover Workshop

# Setup

Install the prover
```
brew reinstall --formula ./revive-prover.rb
```

Clone the Sui repo clone and checkout the `next` branch
```
git clone https://github.com/asymptotic-code/sui.git
cd sui
git checkout next
```

# Execute the prover
```
sui-move build --prove
```
