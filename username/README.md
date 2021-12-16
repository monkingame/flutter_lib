# username
generate usernames(support Chinese and English lauguages now.)


## Getting Started
generate random usernames

## Usage
```
final user2 = Username.cn();
// 姚燕(实际名称随机产生)
print(user2.fullname);

final user3 = Username.cn();
// 严梓宣, 秦浩轩, 苏玉英, 曹徳明, 苏鹏, 邵浩轩, 陈子轩, 顾建国, 严玉兰, 高倩
// (实际名称随机产生)
print(user3.getFullnames(count: 10));

final user4 = Username.cn(surName: '王');
// 王波, 王国华, 王敏, 王俊杰, 王娟, 王宇, 王宇航, 王英, 王婷婷, 王和平
// (实际名称随机产生)
print(user4.getFullnames(count: 10));

final user5 = Username.en();
// Scarlett Morris, Micah Doherty, Samuel Sullivan, Makayla Turner, Ethan Miller, Braxton Perez, Nevaeh MacDonald, Natalie Bennett, Kayla Carter, Oakley Reyes
// (actual usernames generated random)
print(user5.getFullnames(count: 10));
```

