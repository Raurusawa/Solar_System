#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoord;

out vec3 FragPos;
out vec3 Normal;
out vec3 ViewNormal;
out vec2 TexCoord;

uniform mat4 model;
uniform mat4 view;        // 完整 view 矩阵（含平移），用于 ViewNormal
uniform mat4 viewRot;     // view 矩阵去掉平移部分（仅旋转），用于 gl_Position
uniform mat4 projection;

void main() {
    // model 矩阵的 translate 部分 = worldPos - cameraPos（相机相对坐标）
    // FragPos 保持相机相对坐标，不做 +cameraPos！
    // 否则 FragPos ≈ 1500.0 (float)，0.00056 量级天体被量化成 ~6 个离散级 → 三角形条纹
    vec4 relPos = model * vec4(aPos, 1.0);
    FragPos = vec3(relPos);
    Normal = mat3(model) * aNormal;
    ViewNormal = normalize(mat3(view) * mat3(model) * aNormal);
    TexCoord = aTexCoord;
    // 用仅含旋转的 viewRot 变换避免 cameraPos 被减两次
    gl_Position = projection * viewRot * relPos;
}
