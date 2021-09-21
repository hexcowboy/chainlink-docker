FROM smartcontract/chainlink:0.10.14

ENTRYPOINT ["chainlink"]
CMD ["local", "node", "-p", "/srv/credentials.txt", "-a", "/srv/api.txt"]
