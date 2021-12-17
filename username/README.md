# username
generate usernames(support Chinese and English lauguages now.)


## Getting Started
generate random usernames

## Usage
```
// Eli Murphy (actual usernames generated random)
print(Username.en().fullname);

// Alexander Robertson, Lincoln Sullivan, Ezekiel Jenkins
// (actual usernames generated random)
print(Username.en().getFullnames(count: 3));

// Mason Jackson, Gavin Jackson, Aubree Jackson
// (actual usernames generated random)
print(Username.en(surName: 'Jackson').getFullnames(count: 3));

// 姚宇 (实际名称随机产生)
print(Username.cn().fullname);

// 李红梅, 李波, 邵玉兰, 史芳, 陶梓涵, 汪超
// (实际名称随机产生)
print(Username.cn().getFullnames(count: 6));

// 王建军, 王敏, 王红, 王皓轩, 王波, 王梓宣
// (实际名称随机产生)
print(Username.cn(surName: '王').getFullnames(count: 6));
```

