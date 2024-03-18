import React from 'react'
import Svg, { Circle, Defs, ClipPath, Use, G, Path } from 'react-native-svg'

export const PersonIcon = props => {
    let color = props.color ? props.color : "#6C7E8B";
    return (
        <Svg
            id="prefix__Layer_1"
            x={0}
            y={0}
            viewBox="0 0 979 979"
            xmlSpace="preserve"
            {...props}
        >
            <Circle className="prefix__st0" fill="#FFF" cx={489.5} cy={489.5} r={467.47} />
            <Circle className="prefix__st4" fill={color} cx={489.5} cy={489.5} r={489.5} />
            <Circle className="prefix__st0" fill="#FFF" cx={489.5} cy={489.5} r={467.47} />
            <Defs>
                <Circle
                    id="prefix__SVGID_3_"
                    transform="rotate(-45.001 489.496 489.509)"
                    cx={489.5}
                    cy={489.5}
                    r={405.63}
                />
            </Defs>
            <ClipPath id="prefix__SVGID_2_">
                <Use xlinkHref="#prefix__SVGID_3_" overflow="visible" />
            </ClipPath>
            <G clipPath="url(#prefix__SVGID_2_)">
                <Path
                    fill={color}
                    className="prefix__st4"
                    d="M347.52 573.6c22.04 28.56 47.98 50.19 81.53 63.18 61.04 23.64 115.89 11.84 165.25-26.06 12.12-9.31 21.73-21.34 32.77-31.88 1.77-1.69 5.59-3.59 7.41-2.93 53.89 19.55 108.48 37.84 158.96 64.28 40.27 21.09 66.69 53.71 85.08 92.35 16.43 34.52 26.45 70.4 29.04 108.02 1.22 17.65-.21 19.65-17.96 26.1-41.19 14.97-84.09 23.91-127.65 30.3-54.78 8.03-109.91 13.35-165.38 14.74-51.94 1.31-103.94 3.09-155.87 2.24-87.69-1.43-175.09-7.27-261.3-23.34-33.26-6.2-65.86-14.57-97.24-26.71-7.36-2.85-11.41-7.15-11.02-14.46 3.62-66.76 23.68-127.96 72.94-178.91 21.63-22.38 49.69-36.45 79.1-48.2 41.16-16.44 82.55-32.37 124.34-48.72z"
                />
                <Path
                    fill={color}
                    className="prefix__st4"
                    d="M489.02 104.88c41.89 1.22 81.07 9.62 114.03 36.49 34.83 28.4 50.45 66.48 52.7 110.46.96 18.64.12 37.37.66 56.05.1 3.33 2.16 7.46 4.67 9.71 6.83 6.14 9.63 13.89 10.94 22.46 6.02 39.26-5.51 74.16-28.91 104.91-10.9 14.33-19.2 29.19-26.33 45.69-20.75 48.02-54.53 82.59-107.76 93.42-35.22 7.17-66.45-3.83-94.49-24.7-29.71-22.11-48.12-52.18-59.58-87-1.59-4.82-4.66-9.47-8.03-13.35-29.67-34.09-46.42-72.44-40.03-118.65 1.28-9.24 4.35-17.41 12.02-23.55 1.76-1.41 2.68-4.94 2.6-7.44-.88-26.72-1.18-53.36 6.35-79.41 3.97-13.73 9.26-26.65 20.09-36.64 1.83-1.69 3.63-4.21 4-6.57 5.53-35.51 28.43-55.2 60.29-66.95 24.95-9.22 50.69-14.24 76.78-14.93z"
                />
            </G>
        </Svg>
    )
}