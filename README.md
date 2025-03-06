# Move Prover Workshop

# Setup

Install the prover
```
brew reinstall --formula ./homebrew-formula/revive-prover.rb
```

```
export DOTNET_ROOT=$HOMEBREW_PREFIX/opt/dotnet/libexec
export BOOGIE_EXE=$(which boogie)
export Z3_EXE=$(which z3)
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
