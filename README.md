# Move Prover Workshop

# Setup

Install the prover
```
brew install --formula ./homebrew-formula/sui-move-prover.rb
```

Clone the Sui repo clone and checkout the `next` branch
```
git clone https://github.com/asymptotic-code/sui.git
cd sui
git checkout next
cd ..
```

# Execute the prover
```
sui-move build --prove
```
